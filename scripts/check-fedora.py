#!/usr/bin/env python3
"""Read-only prerequisite probes; does not start a desktop, copy data or change themes."""
import importlib.util
import pathlib
import shutil
import subprocess
import tempfile
from fedora_common import ROOT, RANGES, compatible, require_fedora

def check():
    errors = []
    for command in ('Hyprland', 'hyprctl', 'quickshell', 'matugen', 'cliphist', 'wl-copy',
                    'wl-paste', 'swww', 'swww-daemon', 'uwsm', 'hyprlock', 'hyprsunset',
                    'hyprpicker', 'kitty', 'nwg-look', 'grim', 'slurp', 'satty', 'pactl',
                    'nmcli', 'bluetoothctl', 'playerctl', 'brightnessctl', 'ddcutil',
                    'nvim', 'zsh', 'git', 'notify-send', 'qt6ct'):
        if not shutil.which(command):
            errors.append('Missing command: ' + command)
    for name in RANGES:
        result = subprocess.run(['rpm', '-q', '--queryformat', '%{VERSION}', name],
                                capture_output=True, text=True, timeout=15)
        if result.returncode or not compatible(name, result.stdout.strip()):
            errors.append('Missing/incompatible interface version: ' + name)
        else:
            print('INTERFACE:', name, result.stdout.strip())
    result = subprocess.run(['/usr/bin/python3', '-c',
        'import sass, dbus; from gi.repository import GLib; '
        'assert "color: red" in sass.compile(string="a { color: red; }")'],
        capture_output=True, timeout=15)
    if result.returncode:
        errors.append('System Python requires working sass, dbus and GLib bindings.')
    if shutil.which('matugen'):
        spec = importlib.util.spec_from_file_location('palette_probe', ROOT/'home/.config/hypr/quickshell/scripts/matugen_compat.py')
        probe = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(probe)
        try:
            probe.palette('matugen', ['color', 'hex', '#4285f4'])
            print('PALETTE: Matugen JSON colors compatible.')
        except (OSError, ValueError, KeyError, RuntimeError, subprocess.SubprocessError) as error:
            errors.append('Matugen palette incompatible: ' + str(error))
    if shutil.which('fc-list'):
        families = subprocess.run(['fc-list', '--format=%{family}\n'], capture_output=True,
                                  text=True, check=True, timeout=15).stdout
        installed = {family.strip() for line in families.splitlines() for family in line.split(',')}
        for family in ('Rubik', 'JetBrainsMono Nerd Font Mono'):
            if family not in installed:
                errors.append('Exact font family missing: ' + family + ' (see FEDORA.md)')
    else:
        errors.append('fontconfig tools unavailable.')
    cursors = (pathlib.Path.home()/'.local/share/icons/Bibata-Modern-Ice',
               pathlib.Path.home()/'.icons/Bibata-Modern-Ice',
               pathlib.Path('/usr/share/icons/Bibata-Modern-Ice'))
    if not any((p/'index.theme').is_file() and (p/'cursors').is_dir() for p in cursors):
        errors.append('Bibata-Modern-Ice missing; install from the reviewed upstream theme.')
    if not pathlib.Path('/usr/share/wayland-sessions/hyprland-uwsm.desktop').is_file():
        errors.append('Hyprland UWSM display-manager session missing (hyprland-uwsm package).')
    print('Still test in-session: QML imports, NVIDIA/OpenGL, PAM locking, portals, permissions, audio/network/Bluetooth, notifications and theme sync.')
    if errors:
        raise ValueError('\n  ' + '\n  '.join(errors))
    print('Probes passed; graphical restore still UNTESTED on Fedora.')

if __name__ == '__main__':
    try:
        require_fedora()
        check()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        raise SystemExit('FAILED: ' + str(error))
