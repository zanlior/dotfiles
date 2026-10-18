#!/usr/bin/env python3
"""Install reviewed Fedora-native apps; report all separately sourced apps."""
import argparse
import subprocess
from fedora_common import ROOT, install

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--apply', '--execute', dest='apply', action='store_true')
    modes.add_argument('--dry-run', action='store_true')
    parser.add_argument('--new-install-ready', action='store_true')
    args = parser.parse_args()
    print('Separate source review and installation still REQUIRED:')
    print((ROOT/'packages/fedora-manual-apps.md').read_text())
    install('packages/fedora-apps.txt', args.apply, args.new_install_ready)
    print('Excluded apps remain excluded. No current data is removed. Required Python runtime is retained.')

if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        raise SystemExit('FAILED: ' + str(error))
