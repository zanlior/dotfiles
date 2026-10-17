#!/usr/bin/env bash
# No fetching, installing or deletion. Builds an already reviewed local recipe as normal user.
set -euo pipefail
if (($# != 2)); then printf 'Usage: %s REVIEWED_RECIPE_DIR --dry-run|--execute-reviewed\n' "$0" >&2; exit 2; fi
recipe=$1
mode=$2
[[ $mode == --dry-run || $mode == --execute-reviewed ]] || exit 2
[[ -d $recipe && -f $recipe/PKGBUILD && ! -L $recipe/PKGBUILD ]] || { printf 'Recipe missing or symlink.\n' >&2; exit 1; }
(( EUID != 0 )) || { printf 'Refusing root build.\n' >&2; exit 1; }
printf 'Before execution: review PKGBUILD, .install and source files; confirm trusted origin and all dependencies.\n'
if [[ $mode == --dry-run ]]; then printf 'DRY RUN: would run makepkg in reviewed tree.\n'; exit 0; fi
cd -- "$recipe"
# No --syncdeps or --install: package/dependency installation is a separate explicit operation.
exec makepkg --check
