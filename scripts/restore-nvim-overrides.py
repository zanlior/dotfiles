#!/usr/bin/env python3
"""Restore custom NvChad additions AFTER :Lazy restore. Preview by default."""
import argparse
import datetime
import hashlib
import json
import os
import pathlib
import shutil
import subprocess

ROOT = pathlib.Path(__file__).resolve().parents[1]


def safe_relative(name):
    path = pathlib.PurePosixPath(name)
    if path.is_absolute() or '..' in path.parts or not path.parts:
        raise ValueError('Unsafe snapshot path')
    return pathlib.Path(*path.parts)


def no_symlink_parents(path, home):
    for parent in path.parents:
        if parent == home:
            return
        if parent.is_symlink():
            raise ValueError('Existing parent symlink needs review: ' + str(parent))
    raise ValueError('Destination outside home')


def plan(home):
    manifest = json.loads((ROOT / 'nvim-overrides/manifest.json').read_text())
    lock = json.loads((home / '.config/nvim/lazy-lock.json').read_text())
    for plugin, expected in manifest['plugins'].items():
        if plugin not in {'NvChad', 'base46'}:
            raise ValueError('Unexpected plugin')
        path = home / '.local/share/nvim/lazy' / plugin
        no_symlink_parents(path / '.git', home)
        if not (path / '.git').exists():
            raise ValueError('Plugin not installed: ' + plugin + '; run :Lazy restore, close Neovim, then retry')
        if lock.get(plugin, {}).get('commit') != expected:
            raise ValueError('Lockfile changed for ' + plugin + '; review compatibility before applying')
        head = subprocess.run(['git', '-C', str(path), 'rev-parse', 'HEAD'],
                              capture_output=True, text=True, check=True).stdout.strip()
        if head != expected:
            raise ValueError('Plugin version differs for ' + plugin + '; run :Lazy restore or review compatibility')
    files = []
    seen = set()
    for item in manifest['files']:
        source_rel = safe_relative(item['source'])
        rel = safe_relative(item['destination'])
        if not source_rel.is_relative_to('nvim-overrides/lazy'):
            raise ValueError('Source outside overrides')
        if len(rel.parts) < 6 or rel.parts[:4] != ('.local', 'share', 'nvim', 'lazy') or rel.parts[4] not in manifest['plugins']:
            raise ValueError('Destination outside reviewed plugins')
        if rel in seen:
            raise ValueError('Duplicate destination')
        seen.add(rel)
        source = ROOT / source_rel
        if source.is_symlink():
            raise ValueError('Snapshot symlink refused')
        data = source.read_bytes()
        if hashlib.sha256(data).hexdigest() != item['sha256'] or item['mode'] != 0o644:
            raise ValueError('Override checksum or permissions mismatch')
        no_symlink_parents(home / rel, home)
        files.append((rel, data))
    return files


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--home', type=pathlib.Path, default=pathlib.Path.home())
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--apply', action='store_true')
    modes.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    if args.home.is_symlink():
        raise ValueError('Home root symlink refused')
    home = args.home.resolve(strict=True)
    if home == pathlib.Path('/') or home.stat().st_uid != os.getuid():
        raise ValueError('Run as destination user')
    backup = home / '.dotfiles-conflicts' / ('nvim-' + datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
    no_symlink_parents(backup / 'probe', home)
    files = plan(home)
    print(('APPLY' if args.apply else 'PREVIEW') + ': ' + str(len(files)) + ' custom NvChad/Base46 files')
    if not args.apply:
        print('No files written. Close Neovim before --apply.')
        return
    os.umask(0o077)
    changed = 0
    for rel, data in files:
        dest = home / rel
        if dest.is_file() and not dest.is_symlink() and dest.read_bytes() == data:
            continue
        if dest.exists() or dest.is_symlink():
            saved = backup / rel
            saved.parent.mkdir(parents=True, exist_ok=True)
            shutil.move(str(dest), str(saved))
        dest.parent.mkdir(parents=True, exist_ok=True)
        with dest.open('xb') as stream:
            stream.write(data)
        dest.chmod(0o644)
        changed += 1
    print('Changed:', changed, 'Conflicts preserved under:', backup)
    print('Reopen Neovim and check :IslandThemeReload. Reapply after plugin updates if needed, after reviewing compatibility.')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as error:
        raise SystemExit('FAILED: ' + str(error))
