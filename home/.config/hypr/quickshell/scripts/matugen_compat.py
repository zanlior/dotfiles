"""Read Matugen 3.x/4.x palettes without running user templates or hooks."""
import json
import os
import re
import subprocess
import tempfile
from pathlib import Path

REQUIRED = ('background', 'surface_container_low', 'surface_container_high',
            'on_background', 'on_surface_variant', 'primary', 'error', 'secondary',
            'tertiary', 'primary_fixed', 'secondary_fixed')

def palette(binary, source):
    with tempfile.TemporaryDirectory(prefix='island-matugen-') as temp:
        config = Path(temp)/'config.toml'
        config.write_text('[config]\n[templates]\n')
        environment = dict(os.environ, XDG_CACHE_HOME=str(Path(temp)/'cache'))
        help_result = subprocess.run([binary, '--help'], capture_output=True, text=True,
                                     timeout=15, env=environment, check=True)
        flags = ['--config', str(config), '--dry-run', '--json', 'hex', '--mode', 'dark']
        if '--old-json-output' in help_result.stdout:
            flags.append('--old-json-output')
        if '--source-color-index' in help_result.stdout:
            flags.extend(['--source-color-index', '0'])
        result = subprocess.run([binary, *flags, *source], capture_output=True, text=True,
                                timeout=30, env=environment, check=True)
        raw = json.loads(result.stdout)
        colors = raw['colors']
        for name in REQUIRED:
            item = colors[name]['dark']
            if isinstance(item, dict):
                item = item.get('color', item.get('hex'))
            if not isinstance(item, str) or not re.fullmatch(r'#[0-9a-fA-F]{6}', item):
                raise ValueError('Invalid Matugen color: ' + name)
        return raw
