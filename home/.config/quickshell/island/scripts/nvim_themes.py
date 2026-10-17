#!/usr/bin/env python3
"""Island palettes as native NvChad/Base46 themes, with a reversible installer."""
import argparse
import json
import os
import pathlib
import re
import shutil
import subprocess
import time

import themes

SOURCE = themes.ROOT / 'scripts/nvim'


def theme_name(name):
    return 'island_' + name.replace('-', '_')


def palette(name, entry):
    # Some of the user's original Kitty palettes have a different background
    # from the shell palette. Match the actual terminal, including those themes.
    terminal = dict(re.findall(r'(?m)^(\w+)\s+(#[0-9a-fA-F]{6})\s*$', themes.kitty_colors(name, entry)))
    _, panel, card, _, muted, accent = entry['colors']
    bg, fg = terminal['background'], terminal['foreground']
    red, green, yellow, blue, purple, cyan = [terminal[f'color{i}'] for i in range(1, 7)]
    base30 = {
        'white': fg, 'black': bg, 'darker_black': bg, 'black2': panel,
        'one_bg': panel, 'one_bg2': card, 'one_bg3': card,
        'grey': muted, 'grey_fg': muted, 'grey_fg2': muted, 'light_grey': muted,
        'red': red, 'baby_pink': red, 'pink': purple, 'line': card,
        'green': green, 'vibrant_green': green, 'nord_blue': blue, 'blue': blue,
        'yellow': yellow, 'sun': yellow, 'purple': purple, 'dark_purple': purple,
        'teal': cyan, 'orange': yellow, 'cyan': cyan, 'statusline_bg': panel,
        'lightbg': card, 'pmenu_bg': accent, 'folder_bg': accent,
    }
    base16 = dict(zip(
        ['base00', 'base01', 'base02', 'base03', 'base04', 'base05', 'base06', 'base07',
         'base08', 'base09', 'base0A', 'base0B', 'base0C', 'base0D', 'base0E', 'base0F'],
        [bg, panel, card, muted, muted, fg, fg, fg, red, yellow, yellow, green, cyan, blue, purple, red],
    ))
    def lua_table(values):
        return '{\n' + ''.join(f'  {key} = "{value}",\n' for key, value in values.items()) + '}'
    dynamic = 'M = require("island_theme").material_palette(M)\n' if name == 'material-you' else ''
    return (
        f'-- Generated Island / NvChad palette: {name}\nlocal M = {{}}\n\n'
        f'M.base_30 = {lua_table(base30)}\n\nM.base_16 = {lua_table(base16)}\n\n'
        f'M.type = "{"light" if name == "e-ink" else "dark"}"\n'
        'M.polish_hl = {\n  defaults = {\n'
        '    NormalNC = { bg = "NONE" },\n'
        '    SignColumn = { bg = "NONE" },\n'
        '    FoldColumn = { bg = "NONE" },\n'
        f'    EndOfBuffer = {{ fg = "{bg}", bg = "NONE" }},\n'
        '  },\n}\n\n'
        + dynamic + f'return require("base46").override_theme(M, "{theme_name(name)}")\n'
    )


def files(data):
    """Keep the complete hook inside the copyable Neovim data folder."""
    plugin = data / 'lazy/NvChad'
    result = {
        plugin / 'lua/island_theme.lua': (SOURCE / 'island_theme.lua').read_text(),
        plugin / 'plugin/island-theme.lua': (SOURCE / 'plugin.lua').read_text(),
    }
    for variant, colors in themes.REGISTRY.items():
        result[data / 'lazy/base46/lua/base46/themes' / (theme_name(variant) + '.lua')] = palette(variant, colors)
    return result


def reload_sessions():
    """Bootstrap already-open local sessions on installation without closing buffers."""
    warnings = []
    runtime = pathlib.Path(os.environ.get('XDG_RUNTIME_DIR', f'/run/user/{os.getuid()}'))
    for folder in runtime.glob('nvim.*'):
        if not folder.is_dir():
            continue
        for socket in folder.iterdir():
            if not socket.is_socket() or not socket.name.startswith('nvim.'):
                continue
            try:
                expr = 'luaeval(\'require("island_theme").setup()\')'
                proc = subprocess.run(['nvim', '--server', str(socket), '--remote-expr', expr], capture_output=True, text=True, timeout=5)
                if proc.returncode:
                    warnings.append(f'{socket.name}: {proc.stderr.strip()}')
            except (OSError, subprocess.TimeoutExpired) as error:
                warnings.append(f'{socket.name}: {error}')
    return warnings


def install(data):
    if not (data / 'lazy/NvChad/lua/nvchad').is_dir() or not (data / 'lazy/base46/lua/base46').is_dir():
        raise RuntimeError('No installed NvChad / Base46 found under ' + str(data))
    changes = files(data)
    backup = themes.ROOT / 'backups' / time.strftime('nvim-themes-%Y%m%d-%H%M%S')
    backup.mkdir(parents=True)
    manifest = {}
    for path in changes:
        relative = str(path.relative_to(data))
        if path.is_symlink():
            manifest[relative] = {'link': os.readlink(path)}
        elif path.exists():
            destination = backup / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, destination)
            manifest[relative] = {'file': relative}
        else:
            manifest[relative] = {'missing': True}
    (backup / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    themes.write_files(changes)
    print('Installed all NvChad palettes. Backup:', backup)
    for warning in reload_sessions():
        print('Session reload:', warning)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--install', action='store_true', help='Back up and sync the active NvChad configuration')
    parser.add_argument('--generate', action='store_true', help='Generate reviewable Base46 palette files in themes/variants')
    parser.add_argument('--package', action='store_true', help='Update the copyable docs/nvim folder with all palettes and the sync hook')
    parser.add_argument('--data', type=pathlib.Path, default=pathlib.Path(os.environ.get('XDG_DATA_HOME', pathlib.Path.home() / '.local/share')) / 'nvim')
    args = parser.parse_args()
    if args.generate:
        for name, entry in themes.REGISTRY.items():
            themes.atomic(themes.ROOT / 'themes/variants' / name / 'nvim.lua', palette(name, entry))
        print('Generated', len(themes.REGISTRY), 'NvChad palettes')
    if args.install:
        install(args.data)
    if args.package:
        themes.write_files(files(themes.ROOT / 'docs/nvim'))
        print('Updated docs/nvim; copy it to ~/.local/share/nvim')
    if not args.generate and not args.install and not args.package:
        parser.error('Choose --generate, --package or --install')
