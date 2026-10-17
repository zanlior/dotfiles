#!/usr/bin/env python3
"""Regenerate ZuriTheme from Island palettes and build an offline-installable VSIX."""
import argparse
import json
import os
import re
import subprocess
import xml.etree.ElementTree as ET
import zipfile

import themes

PROJECT = themes.ROOT / 'docs/zuritheme'
VSIX_NS = 'http://schemas.microsoft.com/developer/vsx-schema/2011'


def build():
    file = PROJECT / 'src/palettes.json'
    presets = json.loads(file.read_text())
    palettes = {}
    for name, entry in themes.REGISTRY.items():
        preset = presets.get(name, {})
        terminal = dict(re.findall(r'(?m)^(\w+)\s+(#[0-9a-fA-F]{6})\s*$', themes.kitty_colors(name, entry)))
        palettes[name] = dict(entry, label=preset.get('label', name.replace('-', ' ').title()),
                             base=preset.get('base', 'Carbon'), terminal=terminal)
    themes.atomic(file, json.dumps(palettes, indent=2, ensure_ascii=False) + '\n')
    subprocess.run(['node', str(PROJECT / 'scripts/build.js')], check=True)


def package():
    metadata = json.loads((PROJECT / 'package.json').read_text())
    original = PROJECT / 'zuritheme-0.0.1.vsix'
    with zipfile.ZipFile(original) as archive:
        manifest = ET.fromstring(archive.read('extension.vsixmanifest'))
        types = ET.fromstring(archive.read('[Content_Types].xml'))
    def tag(name):
        return '{' + VSIX_NS + '}' + name
    manifest.find('.//' + tag('Identity')).set('Version', metadata['version'])
    manifest.find('.//' + tag('Description')).text = metadata['description']
    manifest.find('.//' + tag('Tags')).text = 'theme,color-theme,icon-theme,island'
    properties = manifest.find('.//' + tag('Properties'))
    values = {'Microsoft.VisualStudio.Code.ExtensionKind': 'ui', 'Microsoft.VisualStudio.Code.ExecutesCode': 'true'}
    for key, value in values.items():
        existing = next((item for item in properties if item.get('Id') == key), None)
        if existing is None:
            existing = ET.SubElement(properties, tag('Property'), {'Id': key})
        existing.set('Value', value)
    ET.SubElement(types, '{http://schemas.openxmlformats.org/package/2006/content-types}Default',
                  {'Extension': '.js', 'ContentType': 'application/javascript'})
    destination = PROJECT / f'zuritheme-{metadata["version"]}.vsix'
    temporary = destination.with_suffix('.vsix.tmp')
    try:
        with zipfile.ZipFile(temporary, 'w', compression=zipfile.ZIP_DEFLATED) as archive:
            archive.writestr('extension.vsixmanifest', ET.tostring(manifest, encoding='utf-8', xml_declaration=True))
            archive.writestr('[Content_Types].xml', ET.tostring(types, encoding='utf-8', xml_declaration=True))
            for filename in ('package.json', 'icon.png', 'extension.js'):
                archive.write(PROJECT / filename, 'extension/' + filename)
            archive.write(PROJECT / 'README.md', 'extension/readme.md')
            for directory in ('build', 'src'):
                for file in sorted((PROJECT / directory).rglob('*')):
                    if file.is_file():
                        archive.write(file, 'extension/' + str(file.relative_to(PROJECT)))
        os.replace(temporary, destination)
    finally:
        if temporary.exists():
            temporary.unlink()
    print('Packaged:', destination)
    return destination


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--package', action='store_true', help='Also build the VSIX package')
    args = parser.parse_args()
    build()
    if args.package:
        package()
