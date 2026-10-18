#!/usr/bin/env python3
"""Fedora 44 desktop prerequisite planner. Dry-run default; --apply is opt-in."""
import argparse
import importlib.util
import subprocess
from fedora_common import ROOT, install, require_fedora

def check_runtime():
    spec = importlib.util.spec_from_file_location('fedora_check', ROOT/'scripts/check-fedora.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.check()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--apply', action='store_true')
    modes.add_argument('--dry-run', action='store_true')
    modes.add_argument('--check-only', action='store_true')
    parser.add_argument('--new-install-ready', action='store_true')
    args = parser.parse_args()
    if args.check_only:
        require_fedora()
        check_runtime()
        return
    install('packages/fedora-desktop.txt', args.apply, args.new_install_ready)
    if args.apply:
        check_runtime()

if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        raise SystemExit('FAILED: ' + str(error))
