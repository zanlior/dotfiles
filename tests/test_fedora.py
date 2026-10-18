"""Offline migration safety checks; no package installation or restoration."""
import contextlib
import importlib.util
import io
import json
import pathlib
import subprocess
import sys
import unittest
from unittest.mock import patch

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT/'scripts'))
import fedora_common as fedora

def load_palette(profile='hypr/quickshell'):
    path = ROOT/'home/.config'/profile/'scripts/matugen_compat.py'
    spec = importlib.util.spec_from_file_location('palette_test', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

class FedoraSafety(unittest.TestCase):
    def invoke_plan(self, available, installed='', names=None):
        names = names or ['hyprland', 'quickshell', 'cliphist']
        replies = [subprocess.CompletedProcess([], 0, available, ''),
                   subprocess.CompletedProcess([], 1, installed, '')]
        with patch.object(fedora.subprocess, 'run', side_effect=replies) as run:
            with contextlib.redirect_stdout(io.StringIO()):
                result = fedora.plan(names)
            self.assertEqual(len(run.call_args_list), 2)
            for call in run.call_args_list:
                self.assertNotIn('sudo', call.args[0])
                self.assertNotIn('install', call.args[0])
            self.assertIn('--cacheonly', run.call_args_list[0].args[0])
            return result

    def test_complete_plan_pins_interface_versions(self):
        result = self.invoke_plan('hyprland\t0.56.2\nquickshell\t0.3.2\ncliphist\t0.6.1\n')
        self.assertIn('hyprland-0.56.2', result)
        self.assertIn('quickshell-0.3.2', result)
        self.assertNotIn('-y', result)
        self.assertNotIn('--allowerasing', result)
        self.assertNotIn('--skip-unavailable', result)

    def test_missing_package_is_fatal(self):
        with self.assertRaisesRegex(ValueError, 'cliphist'):
            self.invoke_plan('hyprland\t0.56.2\nquickshell\t0.3.2\n')

    def test_old_qml_version_is_fatal(self):
        with self.assertRaisesRegex(ValueError, 'quickshell'):
            self.invoke_plan('hyprland\t0.56.2\nquickshell\t0.2.1\ncliphist\t0.6.1\n')

    def test_next_hyprland_interface_requires_review(self):
        with self.assertRaisesRegex(ValueError, 'hyprland'):
            self.invoke_plan('hyprland\t0.57.0\nquickshell\t0.3.2\ncliphist\t0.6.1\n')

    def test_incompatible_installed_version_never_auto_downgrades(self):
        with self.assertRaisesRegex(ValueError, 'installed interface'):
            self.invoke_plan('hyprland\t0.56.2\nquickshell\t0.3.2\ncliphist\t0.6.1\n', 'hyprland\t0.57.0\n')

    def test_rerun_with_all_installed_is_noop(self):
        rows = 'hyprland\t0.56.2\nquickshell\t0.3.2\ncliphist\t0.6.1\n'
        self.assertIsNone(self.invoke_plan('', rows))

    def test_apply_needs_explicit_new_install_readiness(self):
        with patch.object(fedora, 'require_fedora'), patch.object(fedora, 'plan') as planner:
            with self.assertRaisesRegex(ValueError, 'new-install-ready'):
                fedora.install('packages/fedora-desktop.txt', apply=True)
            planner.assert_not_called()

    def test_cachyos_rejected_before_commands(self):
        with patch.object(fedora.platform, 'freedesktop_os_release', return_value={'ID':'cachyos', 'VERSION_ID':'2026'}), patch.object(fedora.subprocess, 'run') as run:
            with self.assertRaisesRegex(ValueError, 'Fedora 44'):
                fedora.require_fedora()
            run.assert_not_called()

    def test_wrong_release_rejected(self):
        with patch.object(fedora.platform, 'freedesktop_os_release', return_value={'ID':'fedora', 'VERSION_ID':'43'}):
            with self.assertRaises(ValueError):
                fedora.require_fedora()

    def test_plan_lists_are_checksum_verified(self):
        for name in ('fedora-desktop.txt', 'fedora-apps.txt'):
            self.assertTrue(fedora.verified_list('packages/'+name))

    def test_retained_applications_all_have_routes(self):
        coverage = json.loads((ROOT/'packages/fedora-app-coverage.json').read_text())['items']
        for name in ('final-repository-packages.txt', 'final-foreign-review.txt', 'final-foreign-dependency-review.txt', 'final-manual-review.txt'):
            for original in (ROOT/'review'/name).read_text().splitlines():
                self.assertIn(original.split(' | ')[0], [r['original'] for r in coverage])
        self.assertTrue(any(row['original']=='proton-pass' for row in coverage))
        self.assertTrue(any(row['original']=='proton-mail-bin' for row in coverage))

class PaletteCompatibility(unittest.TestCase):
    def probe(self, modern, invalid=False, profile='hypr/quickshell'):
        module = load_palette(profile)
        colors = {key: {'dark': {'color':'#123456'} if modern else '#123456'} for key in module.REQUIRED}
        if invalid:
            colors['primary']['dark'] = 'invalid'
        calls = []
        def run(argv, **kwargs):
            calls.append(argv)
            if '--help' in argv:
                return subprocess.CompletedProcess(argv, 0, '--source-color-index '+('--old-json-output' if modern else ''), '')
            config = pathlib.Path(argv[argv.index('--config')+1])
            self.assertEqual(config.read_text(), '[config]\n[templates]\n')
            self.assertIn('--dry-run', argv)
            return subprocess.CompletedProcess(argv, 0, json.dumps({'colors':colors}), '')
        with patch.object(module.subprocess, 'run', side_effect=run):
            result = module.palette('matugen', ['image', '/tmp/test-wallpaper.png'])
        self.assertEqual('--old-json-output' in calls[-1], modern)
        self.assertIn('primary', result['colors'])

    def test_v3_legacy_palette(self):
        self.probe(False)

    def test_v4_legacy_output_flag(self):
        self.probe(True)

    def test_second_shell_profile_has_same_adapter(self):
        self.probe(True, profile='quickshell/island')

    def test_invalid_color_rejected(self):
        with self.assertRaisesRegex(ValueError, 'Invalid Matugen color'):
            self.probe(True, invalid=True)

if __name__ == '__main__':
    unittest.main()
