#!/usr/bin/env python3
"""Check dependencies; install ONLY with --apply on the NEW, fully updated system."""
import argparse
import json
import os
import pathlib
import re
import shutil
import subprocess
import tempfile


def check_runtime():
    """Check packaged helpers without starting clipboard tracking or changing themes."""
    missing = [name for name in ('cliphist', 'matugen', 'wl-paste') if not shutil.which(name)]
    if missing:
        raise ValueError('Required commands unavailable on PATH: ' + ', '.join(missing))
    # Exercise the JSON interface used by the bar, isolated from user templates.
    # --dry-run prevents hooks, wallpaper changes and template output.
    with tempfile.TemporaryDirectory(prefix='dotfiles-matugen-check-') as temp:
        config = pathlib.Path(temp) / 'config.toml'
        config.write_text('[config]\n[templates]\n')
        palette = subprocess.run(
            ['matugen', '--config', str(config), '--dry-run', '--old-json-output',
             '--json', 'hex', '--mode', 'dark', '--source-color-index', '0',
             'color', 'hex', '#4285f4'], capture_output=True, text=True, timeout=30,
            env=dict(os.environ, XDG_CACHE_HOME=str(pathlib.Path(temp) / 'cache')),
        )
        if palette.returncode:
            raise ValueError('Matugen palette check failed; its CLI may be incompatible with the bar')
        try:
            colors = json.loads(palette.stdout)['colors']
            for name in ('background', 'surface_container_low', 'surface_container_high',
                         'on_background', 'on_surface_variant', 'primary', 'error',
                         'secondary', 'tertiary', 'primary_fixed', 'secondary_fixed'):
                value = colors[name]['dark']
                if isinstance(value, dict):
                    value = value.get('color', value.get('hex'))
                if not isinstance(value, str) or not re.fullmatch(r'#[0-9a-fA-F]{6}', value):
                    raise ValueError('Invalid palette color')
        except (KeyError, TypeError, ValueError) as error:
            raise ValueError('Matugen JSON palette is incompatible with the bar') from error
    # The Quickshell backend uses system Python. Compile a tiny in-memory sample
    # to check the Python binding and its native LibSass library together.
    probe = subprocess.run(
        ['/usr/bin/python3', '-c',
         'import sass; css = sass.compile(string="a { color: red; }"); '
         'assert "color: red" in css'],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
    )
    if probe.returncode:
        raise ValueError('python-libsass runtime check failed; system Python must import sass and compile SCSS')
    print('Runtime checks passed: cliphist/wl-paste available, Matugen palette compatible and Python LibSass compiles.')
    print('Check clipboard history and Material You theme generation inside the restored desktop session.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--apply', action='store_true')
    modes.add_argument('--dry-run', action='store_true')
    modes.add_argument('--check-only', action='store_true', help='Check installed helper commands and Python LibSass; install nothing')
    args = parser.parse_args()
    if args.check_only:
        check_runtime()
        return
    root = pathlib.Path(__file__).resolve().parents[1]
    packages = [v for v in (root / 'packages/desktop-required.txt').read_text().splitlines()
                if v and not v.startswith('#')]
    if any(not re.fullmatch(r'[a-zA-Z0-9@+_.-]+', v) for v in packages):
        raise ValueError('Invalid package name')
    unavailable = [name for name in packages if subprocess.run(
        ['pacman', '-Si', '--', name], stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL).returncode]
    if unavailable:
        raise ValueError('Missing/renamed packages; resolve before continuing: ' + ', '.join(unavailable))
    print('Required packages:', ', '.join(packages))
    if args.apply:
        subprocess.run(['sudo', 'pacman', '-S', '--needed', '--', *packages], check=True)
        check_runtime()
    else:
        print('PREVIEW: no installation performed. --apply also checks the installed helper commands and Python LibSass.')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        raise SystemExit('FAILED: ' + str(error))
