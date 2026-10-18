# Fedora 44 migration branch — graphical validation pending

This branch adapts the saved custom Hyprland **Lua** + Island/Quickshell desktop for a conventional Fedora 44 x86_64 installation. **Your selected route is Fedora Everything with Minimal Install, then Hyprland only.** It is not an Atomic/Silverblue/Kinoite installer. The CachyOS `main` branch stays separate. No script repartitions, modifies `/etc`, enables services, changes the login shell, installs graphics drivers or reboots. Installation/restoration requires explicit flags on the new system. No live Fedora desktop has been tested yet.

## 1. Preserve recovery and install the base

Finish and independently verify the HDD backup before erasing any SSD data. In particular, refresh `.codex` with Codex closed, and preserve projects such as `Documents/Codex`, shared `.hamlet` workspace/session state and `Applications` separately. A public dotfiles repository does not replace a private backup or recovery image. Keep the HDD untouched during installation, following your latest disk decision.

Use **[Fedora Everything 44 Network Install, x86_64](https://fedoraproject.org/misc/#everything)** and select **Minimal Install** under Software Selection, without extra desktop environments or server roles. The online installer downloads your selected software; “Everything” does not mean it installs every package. Start with [MINIMAL.md](MINIMAL.md) for first-boot networking, bootstrap packages, console recovery and TTY session startup. Workstation/KDE remain optional compatible starting points if already installed; no GNOME/KDE desktop is required or installed by this kit. Configure RTX 3060 support using the current [RPM Fusion NVIDIA instructions](https://rpmfusion.org/Howto/NVIDIA), including Secure Boot enrollment when applicable, matching kernel modules and 32-bit support for Steam. Let module builds complete and reboot before testing OpenGL/Vulkan. Do not use old CachyOS kernels, NVIDIA packages, initramfs, bootloader configuration, `/etc/fstab`, PAM files or copied system services.

Keep SELinux enabled. This kit does not disable it or change kernel arguments. Check any denial before changing policy. A driver/module mismatch can occur after updates on either distribution; don't treat installing Fedora as a substitute for confirming driver readiness.

## 2. Clone this branch

```bash
git clone --branch fedora --single-branch https://github.com/zanlior/dotfiles.git "$HOME/dotfiles-fedora"
cd "$HOME/dotfiles-fedora"
sha256sum -c SHA256SUMS
```

Use a different destination if that folder exists. Cloning downloads files; only the later `restore-desktop.py --apply` copies them into their matching home directories. Never run these scripts through `sudo python3`.

## 3. Review the community package sources

Your Lua config needs Hyprland 0.56.2 (0.56.x interface) and the saved QML requires Quickshell 0.3.2 (0.3.x interface). NvChad needs Neovim 0.11+. Normal package names alone do not establish compatibility. The installer checks these ranges and pins a compatible version for that transaction. It does not permanently freeze updates: newer versions, Qt ABI changes and Fedora upgrades need another compatibility check.

Two candidate community sources have relevant Fedora 44 builds:

- [`sdegler/hyprland`](https://copr.fedorainfracloud.org/coprs/sdegler/hyprland/): [published 0.56.2 build and RPM recipe](https://copr-be.cloud.fedoraproject.org/results/sdegler/hyprland/fedora-44-x86_64/10918511-hyprland/), Hyprland helpers/UWSM, portal, nwg-look, swww, satty and related libraries in its [build index](https://copr-be.cloud.fedoraproject.org/results/sdegler/hyprland/fedora-44-x86_64/).
- [`avengemedia/danklinux`](https://github.com/AvengeMedia/DankLinux): its [Fedora 44 Quickshell index](https://console.redhat.com/api/pulp-content/public-copr/avengemedia/danklinux/fedora-44-x86_64/Packages/q/) shows a tagged 0.3.2 build. Use `quickshell`, not the daily `quickshell-git` variant. Do not install DankMaterialShell: your shell remains Island.

These are community repositories, not Fedora official support. Build existence does not prove a compatible combined dependency solution. Review source recipes, GPG keys, recent build status and the actual DNF transaction. Do not mix other Hyprland COPRs or enable unrelated projects to make a dependency error disappear. No script enables any repository or trusts a key automatically.

**Only on the new Fedora machine, after that source review**, the intended commands are:

```bash
sudo dnf copr enable sdegler/hyprland
sudo dnf copr enable avengemedia/danklinux
dnf makecache
python3 scripts/install-desktop-deps.py --dry-run
```

If `dnf copr` is absent, install the Fedora DNF5 COPR plugin after checking its package name on that release. Missing/renamed packages are errors with their names printed, never silently omitted. The preview uses cached metadata only and does not resolve a full transaction. On apply, DNF shows its dependency transaction for review. Decline unexpected removals or unrelated replacements. The scripts never use automatic yes, `--allowerasing`, `--skip-broken`, or `--skip-unavailable`.

## 4. Install exact appearance prerequisites, then desktop packages

Required families are **Rubik** and **JetBrainsMono Nerd Font Mono**, with cursor **Bibata-Modern-Ice**. The repo preserves theme/design assets but does not contain those system-installed font/cursor packages. Obtain the fonts from [Rubik upstream](https://github.com/googlefonts/rubik) and [Nerd Fonts JetBrainsMono](https://www.nerdfonts.com/font-downloads); review release checksums/licenses. Preserve Inter and Geist Mono Nerd too if you use their saved appearance choices. Extract reviewed font files under `~/.local/share/fonts` and run `fc-cache -f`. Install the reviewed [Bibata cursor release](https://github.com/ful1e5/Bibata_Cursor) as `~/.local/share/icons/Bibata-Modern-Ice`, preserving its `index.theme` and `cursors/` contents. No arbitrary download is executed by this kit.

```bash
python3 scripts/install-desktop-deps.py --apply --new-install-ready
python3 scripts/check-fedora.py
```

The mapping includes **cliphist**, **matugen**, **python3-libsass**, Python D-Bus/GLib bindings, Qt QML modules, network/audio tools, build tools for Neovim plugins and desktop helpers. Fedora's `pipewire-pulseaudio`/`pulseaudio-utils` replace Arch's package naming. `swww` supplies wallpapers instead of `awww`; Island already supports both. Wallpaper/image/audio files still come from your private backup and are not on GitHub.

Matugen 3.x and 4.x use a small compatibility adapter: it inspects supported options, selects the old JSON layout when necessary, uses an isolated empty template configuration with `--dry-run`, and validates all required colors. Both shell profiles use it. System Python must import `sass`, D-Bus and GLib and compile a small SCSS sample. A failed probe stops setup.

## 5. Restore the rice and editors

Close desktop apps; run from the clone as your normal user:

```bash
python3 scripts/restore-desktop.py --dry-run
python3 scripts/restore-desktop.py --apply
```

This copies `home/.config/...` to `~/.config/...`, `.local` appearance assets to matching `.local` paths, and the bundled Oh My Zsh/Powerlevel10k/NvChad configuration and ZuriTheme to their original locations. It verifies archive hashes/paths, skips identical files, refuses unsafe symlink parents and preserves conflicts under `~/.dotfiles-conflicts/`. Apply requires Fedora and passing prerequisite checks. It never blindly merges private browser/editor databases.

Fedora branch adaptations: the same Zsh prompt/framework/theme remain, package aliases use DNF, `ls` uses eza, and `ehypr` edits `hyprland.lua`. Start manually from a local TTY with `uwsm start hyprland.desktop` after completing the checks in MINIMAL.md. TTY autostart stays opt-in with `DOTFILES_HYPR_TTY_AUTOSTART=1`. If you independently choose a display manager, select its **Hyprland (UWSM)** session. Review `chsh -s /usr/bin/zsh` separately if desired. Monitor mode defaults to `preferred` because the captured refresh string was malformed; set your actual preferred refresh after checking `hyprctl monitors`. Old forced GBM/GLX environment variables are removed so Fedora's installed graphics stack can select its backend.

The optional hyprbars bindings require a freshly built compatible Fedora plugin; no old compiled Arch plugin is loaded. Their old machine-specific paths are disabled until reviewed. Super+W expects `zen-browser`; Super+Shift+W expects the original Brave Origin command. Adjust only those launch bindings if your selected native/Flatpak package uses different commands. Alternative-terminal shortcuts require alacritty/foot (included in the desktop mapping).

For native VSCodium install the upstream RPM (see the application table), reopen and confirm ZuriTheme is enabled. Island writes `~/.config/island-shell/theme-state.json`; the restored extension watches it and follows desktop/Material You themes. Flatpak VSCodium uses different paths/permissions and is not covered by this automatic restore.

For NvChad, open `nvim`, allow the pinned plugin bootstrap, run `:Lazy restore`, close Neovim, then:

```bash
python3 scripts/restore-nvim-overrides.py --dry-run
python3 scripts/restore-nvim-overrides.py --apply
```

The override script checks lockfile/plugin revisions and preserves conflicts. Reopen and test `:IslandThemeReload`. Language servers/formatters need their separate tools from the application review. Bundled shell frameworks keep their original source pins; Git-based updates require a separately reviewed checkout, as on the CachyOS branch.

Restore private prayer settings using `restore-prayer.py --private-file /path/to/prayer-time-api-YOUR-DATE.txt --dry-run`, then `--apply`. That private Documents file, wallpaper folders and azan audio never belong in this public clone. Restore projects and `.codex` with Codex closed, keeping ownership and symlinks; reauthentication may be needed. Do not blindly preserve old SELinux security labels from an Arch backup. Review `restorecon` on restored paths if their Fedora labels are incorrect.

## 6. Restore reviewed apps and verify the desktop

Read [every retained non-native application](packages/fedora-manual-apps.md); **Proton Mail and Proton Pass remain Keep**. Follow their official RPM sources separately. Native/RPM Fusion application mappings are in `packages/fedora-apps.txt`; review [RPM Fusion setup](https://rpmfusion.org/Configuration) separately for Steam and applicable media/capture packages.

```bash
python3 scripts/restore-apps.py --dry-run
python3 scripts/restore-apps.py --apply --new-install-ready
```

Original `review/` lists remain immutable CachyOS evidence. Do not feed them to DNF or run Arch build recipes. Excluding an app still means omission from the reinstall plan, never deletion of current files.

Before switching your daily session, test: login/logout and an independent recovery TTY; NVIDIA rendering, Minecraft and suspend; Quickshell QML loading and all bar controls; launcher, tray, notification popups/history (one notification owner); clipboard; screenshots; exact fonts/cursors; nwg-look and GTK3/GTK4 theme switching; Material You from a backed-up wallpaper; ZuriTheme and NvChad synchronization; lock/unlock through Fedora's PAM; one working polkit agent; screen sharing/file chooser portals; audio/media keys, network/Bluetooth pairing, monitor brightness/DDC permissions; private prayer reminders and audio. Keep the installer/recovery USB and a working second TTY until these pass. No additional desktop environment is required.

Services and DDC/i2c permissions require a Fedora host review; merely installing packages does not activate everything. Do not disable SELinux, blanket-change device permissions, or start duplicate polkit/notification agents to work around an error. There is no claim of a successful Fedora graphical restore until this rehearsal passes.
