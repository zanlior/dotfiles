#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' 'STOP: this Fedora branch never runs Arch PKGBUILDs or makepkg.' >&2
printf '%s\n' 'See packages/fedora-manual-apps.md for Fedora/upstream sources. Build reviewed source as a normal user.' >&2
exit 1
