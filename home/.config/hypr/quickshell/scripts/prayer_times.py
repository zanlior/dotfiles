"""AlAdhan timetables with timezone-aware timestamps and an offline cache."""
import datetime as dt
import hashlib
import json
import os
import pathlib
import re
import urllib.parse
import urllib.request
from zoneinfo import ZoneInfo

def prayer_api_base():
    """Read private API configuration restored separately from Documents."""
    path = pathlib.Path(os.environ.get('XDG_CONFIG_HOME', pathlib.Path.home()/'.config'))/'island-shell/prayer-api.json'
    base = os.environ.get('ISLAND_PRAYER_API_BASE', '')
    if not base:
        try:
            base = json.loads(path.read_text()).get('api_base', '')
        except (OSError, ValueError):
            pass
    if not base or not base.startswith('https://'):
        raise ValueError('Restore private prayer API configuration first')
    return base.rstrip('/')+'/'


PRAYERS = ('Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha')
MONTHS = ('Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
          'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', "Sha'ban",
          'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah')


def configuration(settings):
    return [settings['prayerCity'].strip(), settings['prayerCountry'].strip(),
            settings['prayerMethod'], int(settings['prayerHanafi'])]


def parse_day(payload, expected_date):
    if payload.get('code') != 200 or not isinstance(payload.get('data'), dict):
        raise ValueError('Prayer service returned an invalid timetable')
    data = payload['data']
    date = dt.datetime.strptime(data['date']['gregorian']['date'], '%d-%m-%Y').date()
    if date != expected_date:
        raise ValueError('Prayer service returned a different date')
    zone = ZoneInfo(data['meta']['timezone'])
    start = dt.datetime.combine(date, dt.time(), zone)
    end = dt.datetime.combine(date + dt.timedelta(days=1), dt.time(), zone)
    events = []
    for name in PRAYERS:
        value = data['timings'][name]
        match = re.fullmatch(r'(\d{2}):(\d{2})(?:\s+\([^)]*\))?', value)
        if not match:
            raise ValueError('Prayer service returned an invalid time')
        hour, minute = map(int, match.groups())
        instant = dt.datetime.combine(date, dt.time(hour, minute), zone)
        events.append(dict(name=name, time=f'{hour:02}:{minute:02}', epoch=int(instant.timestamp())))
    if any(a['epoch'] >= b['epoch'] for a, b in zip(events, events[1:])):
        raise ValueError('Prayer service returned unordered times')
    hijri = data['date']['hijri']
    day, month, year = int(hijri['day']), int(hijri['month']['number']), int(hijri['year'])
    if not 1 <= day <= 30 or not 1 <= month <= 12 or year < 1:
        raise ValueError('Prayer service returned an invalid Hijri date')
    return dict(date=date.isoformat(), startEpoch=int(start.timestamp()), endEpoch=int(end.timestamp()),
                timezone=zone.key, prayers=events, hijriDate=f'{day} {MONTHS[month - 1]} {year}')


class PrayerService:
    def __init__(self, cache_dir=None, fetch=None):
        self.cache_dir = pathlib.Path(cache_dir) if cache_dir else pathlib.Path(
            os.environ.get('XDG_CACHE_HOME', pathlib.Path.home() / '.cache')) / 'island-shell' / 'prayers'
        self.fetch = fetch or self.fetch_day
        self.memory = {}

    @staticmethod
    def fetch_day(date, config):
        city, country, method, school = config
        params = urllib.parse.urlencode(dict(city=city, country=country, method=method, school=school))
        url = prayer_api_base() + date.strftime('%d-%m-%Y') + '?' + params
        request = urllib.request.Request(url, headers={'User-Agent': 'Island-Prayer-Widget/1.0'})
        with urllib.request.urlopen(request, timeout=10) as response:
            return json.load(response)

    def get(self, settings, now=None):
        now = now or dt.datetime.now(dt.timezone.utc)
        config = configuration(settings)
        if not config[0] or not config[1]:
            return dict(configuration=config, status='unconfigured', days=[], message='Set your prayer location in Settings')
        cache_key = hashlib.sha256(json.dumps(config).encode()).hexdigest()[:20]
        cache_file = self.cache_dir / (cache_key + '.json')
        cached = self.memory.get(cache_key)
        if cached is None:
            try:
                cached = json.loads(cache_file.read_text())
                if cached.get('configuration') != config or not isinstance(cached.get('days'), dict):
                    cached = {}
            except (OSError, ValueError, AttributeError):
                cached = {}
# Use cached API timezone where available; no private place is embedded.
        zone = ZoneInfo(cached.get('timezone', 'UTC'))
        today = now.astimezone(zone).date()
        days = cached.get('days', {})
        refreshed = cached.get('refreshed', 0)
        refresh = now.timestamp() - refreshed >= 21600
        failed = False
        fetched = False
        try:
            first = days.get(today.isoformat())
            if refresh or first is None:
                first = parse_day(self.fetch(today, config), today)
                fetched = True
                zone = ZoneInfo(first['timezone'])
                actual_today = now.astimezone(zone).date()
                if actual_today != today:
                    today = actual_today
                    first = parse_day(self.fetch(today, config), today)
                days[today.isoformat()] = first
            tomorrow = today + dt.timedelta(days=1)
            if refresh or tomorrow.isoformat() not in days:
                days[tomorrow.isoformat()] = parse_day(self.fetch(tomorrow, config), tomorrow)
                fetched = True
            if fetched:
                refreshed = now.timestamp()
        except Exception:
            failed = True
        # Keep yesterday's Isha available before today's Fajr. Fetch it separately
        # so a failure cannot prevent today's or tomorrow's timetable loading.
        yesterday = today - dt.timedelta(days=1)
        if yesterday.isoformat() not in days:
            try:
                days[yesterday.isoformat()] = parse_day(self.fetch(yesterday, config), yesterday)
            except Exception:
                failed = True
        selected = [days[d.isoformat()] for d in (yesterday, today, today + dt.timedelta(days=1)) if d.isoformat() in days]
        if selected:
            cached = dict(configuration=config, timezone=zone.key,
                          days={d['date']: d for d in selected}, refreshed=refreshed)
            self.memory[cache_key] = cached
            try:
                self.cache_dir.mkdir(parents=True, exist_ok=True)
                temporary = cache_file.with_suffix('.tmp')
                temporary.write_text(json.dumps(cached))
                temporary.replace(cache_file)
            except OSError:
                pass  # A read-only cache must not prevent use of a live timetable.
        return dict(configuration=config, days=selected, timezone=zone.key,
                    utcOffset=int(now.astimezone(zone).utcoffset().total_seconds() / 60),
                    status=('cached' if selected else 'error') if failed else 'ready',
                    message=('Saved timetable · reconnecting' if selected else 'Prayer times unavailable · retrying') if failed else '')
