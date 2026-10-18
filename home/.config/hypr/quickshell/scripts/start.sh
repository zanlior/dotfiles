#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if ! command -v quickshell >/dev/null; then
    printf 'Install compatible Fedora Quickshell prerequisites; see FEDORA.md in the dotfiles kit\n' >&2
    exit 1
fi
# Follow the monitor's refresh rate; keep an explicit user override if present.
export QSG_RENDER_LOOP="${QSG_RENDER_LOOP:-threaded}"
exec quickshell --no-duplicate -p "$root_dir"
