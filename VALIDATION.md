# Fedora branch validation

Target: conventional Fedora 44 x86_64. Port prepared from CachyOS snapshot `d2f7891c7616e2155cb8496ff41fb1899ce34b63` without modifying the running desktop or CachyOS branch.

Original theme/archive/sanitization evidence remains in Git history. Original inventories and application decisions remain present. Fedora changes cover DNF package mappings, explicit application coverage, OS/readiness/version guards, both Matugen palette adapters, wallpaper daemon, display-manager startup defaults, portable Zsh aliases and monitor/graphics settings. Optional old compiled hyprbars bindings are disabled pending a compatible rebuild. Fonts/cursor and non-native apps are explicitly reported rather than silently assumed installed.

Validation is performed offline with mocked DNF/RPM commands, source syntax checks and checksum/archive/path checks. No installation or restoration is run by the tests. The current CachyOS Matugen binary can be probed with an isolated empty template config; that does not establish Fedora package compatibility.

**Not yet executed:** Fedora DNF dependency resolution, package installation, live Qt/QML launch, driver build, editor bootstrap, private-data restoration, graphical/session tests or recovery rehearsal. Community build listings are evidence that builds exist, not proof the combined desktop dependencies solve or that every interface works. Follow FEDORA.md and keep a working GNOME/KDE recovery session until real tests pass.

Completed on 2026-10-18:

- 15 offline unit checks passed: package availability/version failures, no automatic downgrade, installed-package reruns, readiness/OS guards, list hashes, complete retained-application coverage, Matugen 3/4 shapes and malformed palette rejection.
- Syntax checks passed for 34 Python files, 111 Lua files, 6 shell/startup files and 3 ZuriTheme JavaScript modules.
- Both asset archives passed every part/full hash, size/member count, file-type and path check: 23,124 archive members. The retained assets and editor extension files were not repackaged.
- The restore preview planned 23,498 files and 1,132 symlinks against an empty temporary home and left it empty. The existing home symlink was correctly refused by a separate preview.
- The Fedora installer preview correctly refused to run on the current CachyOS host. No DNF/sudo/install or restore apply action ran.
- The existing Matugen 4.2 helper passed the new isolated palette adapter with an empty template configuration; this is a CachyOS-only helper probe, not a Fedora graphical test.
- New/changed publication text passed recognized credential-pattern scanning. All inherited files come from the previously sanitized public snapshot; private prayer settings, wallpapers, browser profiles, Codex and personal files remain excluded.

Run the offline checks from this checkout using `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -v`. Verify all published content with `sha256sum -c SHA256SUMS`. A checksum detects content changes, not whether a source is trustworthy.
