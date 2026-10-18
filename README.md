# Fedora branch: Hyprland + Island/Quickshell

Fedora adaptations of your sanitized rice, Oh My Zsh/Powerlevel10k, NvChad and VSCodium ZuriTheme synchronization. The CachyOS snapshot remains on [`main`](https://github.com/zanlior/dotfiles/tree/main).

**Selected setup: Fedora Everything 44 x86_64 → Minimal Install → Hyprland + Quickshell. No GNOME/KDE or graphical login manager required. Graphical restore not yet tested on Fedora.** Version checks, package-name mappings and source review are provided; successful scripts alone do not prove the whole desktop works.

```bash
git clone --branch fedora --single-branch https://github.com/zanlior/dotfiles.git "$HOME/dotfiles-fedora"
cd "$HOME/dotfiles-fedora"
sha256sum -c SHA256SUMS
```

Start with **[MINIMAL.md](MINIMAL.md)** for the installer, console/network bootstrap and session startup. Then follow **[FEDORA.md](FEDORA.md)** in order: base system/NVIDIA readiness, community-source review, fonts/cursor, package preview, restore preview, private state and graphical checks. Do not run the apply commands on your present CachyOS installation. Fedora install/apply entrypoints reject the wrong OS.

After prerequisites pass on the NEW Fedora system:

```bash
python3 scripts/install-desktop-deps.py --dry-run
python3 scripts/install-desktop-deps.py --apply --new-install-ready
python3 scripts/restore-desktop.py --dry-run
python3 scripts/restore-desktop.py --apply
```

Cloning downloads the kit. `restore-desktop.py --apply` copies included files into the matching directories under your home, skips identical files and backs up conflicts. It includes both saved Quickshell profiles, GTK/nwg-look appearance assets, terminal/shell settings and editor theme sources. Nothing is installed or restored just by cloning. Read the full guide before applying.

`cliphist`, `matugen`, Fedora's `python3-libsass`, Python D-Bus/GLib bindings and Qt modules are included in the dependency plan. Both shell profiles have a Matugen 3/4 compatibility adapter. SwayNC, Waybar and rofi are not installed; Island handles notifications and the launcher.

See [retained non-native applications](packages/fedora-manual-apps.md), [native package names](packages/fedora-apps.txt), and [complete original-to-Fedora application coverage](packages/fedora-app-coverage.json). Proton Mail and Proton Pass remain Keep through their official RPM routes. Missing packages stop setup rather than being skipped. Original CachyOS inventories/review files are retained as evidence, not Fedora install lists.

Credentials, browser profiles, databases, clipboard/history, all Codex state/projects, documents, wallpapers and azan audio remain in the **private backup**, not GitHub. The private `Documents/prayer-time-api-*.txt` file is also excluded. Preserve it separately and use the private prayer restore step in the guide. This repo is not a full recovery backup.

See [validation status and remaining checks](VALIDATION.md). No live Fedora installation, system change or graphical restore was performed during preparation.
