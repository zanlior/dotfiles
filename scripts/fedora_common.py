"""Fedora-only planning. Never enable repos or silently skip missing packages."""
import hashlib
import os
import pathlib
import platform
import re
import shlex
import shutil
import subprocess

ROOT = pathlib.Path(__file__).resolve().parents[1]
RANGES = {'hyprland': ((0, 56, 2), (0, 57, 0)),
          'quickshell': ((0, 3, 2), (0, 4, 0)),
          'neovim': ((0, 11, 0), None)}

def version(value):
    match = re.match(r'^(\d+)\.(\d+)(?:\.(\d+))?(?:$|[-+~^])', value)
    if not match:
        raise ValueError('Unrecognized version: ' + value)
    return tuple(int(n or 0) for n in match.groups())

def compatible(name, value):
    if name not in RANGES:
        return True
    lower, upper = RANGES[name]
    found = version(value)
    return found >= lower and (upper is None or found < upper)

def require_fedora():
    release = platform.freedesktop_os_release()
    if release.get('ID') != 'fedora' or release.get('VERSION_ID') != '44':
        raise ValueError('This branch targets Fedora 44. Do not run on CachyOS or another release.')
    if platform.machine() != 'x86_64' or pathlib.Path('/run/ostree-booted').exists():
        raise ValueError('Use conventional Fedora 44 x86_64, not Atomic/rpm-ostree.')
    if os.geteuid() == 0:
        raise ValueError('Run as your normal user; only the explicit DNF transaction uses sudo.')
    if not shutil.which('dnf') or not shutil.which('rpm'):
        raise ValueError('DNF5 and RPM are required.')

def verified_list(relative):
    expected = {}
    for line in (ROOT/'SHA256SUMS').read_text().splitlines():
        checksum, name = line.split('  ', 1)
        expected[name] = checksum
    data = (ROOT/relative).read_bytes()
    if hashlib.sha256(data).hexdigest() != expected.get(relative):
        raise ValueError('List checksum mismatch: ' + relative)
    names = [line.strip() for line in data.decode().splitlines()
             if line.strip() and not line.lstrip().startswith('#')]
    if len(names) != len(set(names)) or any(not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9+_.-]*', n) for n in names):
        raise ValueError('Invalid or duplicate package names')
    return names

def parse_rows(output, names):
    rows = {name: [] for name in names}
    for line in output.splitlines():
        fields = line.split('\t')
        if len(fields) == 2 and fields[0] in rows:
            rows[fields[0]].append(fields[1])
    return rows

def plan(names):
    result = subprocess.run(
        ['dnf', '--quiet', '--cacheonly', 'repoquery', '--available',
         '--arch=x86_64,noarch', '--queryformat', '%{name}\t%{version}\n', *names],
        capture_output=True, text=True, timeout=120)
    if result.returncode:
        raise ValueError('DNF query failed. Review repos, explicitly run dnf makecache, then retry.\n' + result.stderr)
    available = parse_rows(result.stdout, names)
    installed_result = subprocess.run(
        ['rpm', '-q', '--queryformat', '%{NAME}\t%{VERSION}\n', *names],
        capture_output=True, text=True, timeout=30)
    # rpm -q is nonzero if any name is absent; retain successful rows.
    installed = parse_rows(installed_result.stdout, names)
    unresolved, specs = [], []
    for name in names:
        if name in RANGES and installed[name] and not all(compatible(name, v) for v in installed[name]):
            unresolved.append(name + ' (installed interface version incompatible; manual review required)')
            continue
        if any(compatible(name, v) for v in installed[name]):
            print('INSTALLED:', name, ', '.join(installed[name]))
            continue
        candidates = [v for v in available[name] if compatible(name, v)]
        if not candidates:
            unresolved.append(name + (' (unsupported interface version)' if available[name] else ' (not available)'))
            continue
        selected = max(candidates, key=version) if name in RANGES else None
        specs.append(name + '-' + selected if selected else name)
    if unresolved:
        raise ValueError('Resolve EVERY missing/incompatible package before installing:\n  ' + '\n  '.join(unresolved))
    command = ['sudo', 'dnf', '--setopt=install_weak_deps=False', 'install', *specs]
    print('PLAN:', shlex.join(command) if specs else 'All requested packages installed.')
    print('Availability preview only; DNF resolves dependencies in its interactive transaction.')
    return command if specs else None

def install(relative, apply=False, ready=False):
    require_fedora()
    if apply and not ready:
        raise ValueError('--apply requires --new-install-ready after base/driver/repository setup.')
    command = plan(verified_list(relative))
    if apply and command:
        # No -y, allowerasing, skip-broken or skip-unavailable.
        subprocess.run(command, check=True)
    elif not apply:
        print('DRY RUN: no packages installed, no repositories or services changed.')
