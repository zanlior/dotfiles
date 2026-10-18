# CachyOS desktop reinstall snapshot

Sanitized Hyprland Lua, custom Island/Quickshell shell, nwg-look/GTK appearance, themes, icons, Kitty, Quickshell notifications, Neovim configuration and the ZuriTheme VSCodium extension. Relevant `.local` appearance files and the current Zsh/Oh My Zsh/Powerlevel10k setup are included. These are desktop sources/settings, not a complete personal-data or recovery backup.

The original Hyprland launch path `.config/hypr/quickshell` and the separate `.config/quickshell/island` profile differed; both runtime snapshots are preserved. The second profile is stored as actual source files, so it no longer depends on a symlink to a personal development worktree. Project histories, backups, arbitrary project docs, profiles, databases, credentials, clipboard history, browser/media activity, prayer schedules and runtime state are excluded.

API credentials and private prayer location/audio settings are absent. The prayer endpoint is loaded from private local configuration after a separate restore. Preserve the `prayer-time-api-*.txt` file created in your **Documents** folder in your private backup; it is deliberately not on GitHub. The original request uses a keyless public service; the file records the endpoint and settings needed to restore it. Other user files such as wallpapers and azan audio must be recovered from personal backups.

## On the fresh installation

1. Install CachyOS with Hyprland and matching NVIDIA support. Fully update it. Confirm networking, audio, rendering, login/session and a usable terminal. Review the actual installer defaults; the current official profile may start Noctalia, while this snapshot uses the custom shell. Use one intended shell/session setup.
2. Download the snapshot and enter its folder (Git and Python 3 must be available):

   ```bash
   git clone --depth=1 https://github.com/zanlior/dotfiles.git "$HOME/dotfiles"
   cd "$HOME/dotfiles"
   ```

   Cloning only downloads the kit. All scripts default to preview; review them before applying. No script changes machine-specific `/etc`, partitions, boot entries or services.
3. Check/install desktop prerequisites:

   ```bash
   python3 scripts/install-desktop-deps.py --dry-run
   # On the NEW system only, once reviewed:
   python3 scripts/install-desktop-deps.py --apply
   ```

   This installs `cliphist`, `matugen`, `python-libsass` and the other listed prerequisites through pacman. The apply step then verifies that clipboard/theme commands are on PATH, Matugen produces the JSON palette expected by the bar, and system Python can import `sass` and compile SCSS. Missing packages or failed checks stop setup with an error. No pip installation or copied helper binaries are needed.

   To repeat just these checks later, without installing anything:

   ```bash
   python3 scripts/install-desktop-deps.py --check-only
   ```

4. Preview configuration restoration with desktop applications closed:

   ```bash
   python3 scripts/restore-desktop.py --dry-run
   python3 scripts/restore-desktop.py --apply
   ```

   `--apply` automatically copies the included files to their matching locations in your current home directory; no manual copying is needed:

   | Repository location | Restore destination |
   | --- | --- |
   | `home/.config/hypr/` | `~/.config/hypr/` |
   | `home/.config/quickshell/` | `~/.config/quickshell/` |
   | Other `home/.config/` settings | Matching paths under `~/.config/` |
   | `home/.local/` appearance files | Matching paths under `~/.local/` |
   | `home/.gtkrc-2.0` | `~/.gtkrc-2.0` |

   Bundled theme assets are extracted to their recorded home-relative locations, and included symlinks are recreated. The cloned `dotfiles` folder remains the restore kit. Private data and the prayer setup require their separate backups/restoration step below.

   Conflicting destination files are moved to a uniquely named private `.dotfiles-conflicts` folder. Identical files are skipped. Existing parent symlinks require explicit review so writes cannot escape the intended home. Home paths are materialized from `@@HOME@@` templates. Theme assets are stored in checksum-verified compressed parts; their full archive and all member paths are checked before restoration. Do not manually extract parts as independent archives.

5. Restore prayer setup from your private Documents backup, without putting it into this Git checkout:

   ```bash
   python3 scripts/restore-prayer.py --private-file /path/to/prayer-time-api-YOUR-DATE.txt --dry-run
   python3 scripts/restore-prayer.py --private-file /path/to/prayer-time-api-YOUR-DATE.txt --apply
   ```

6. Compare `review/final-base-coverage-check.txt` with installer-provided software. `review/final-repository-packages.txt` lists reviewed supplemental applications; `scripts/restore-apps.py` checks availability before any optional installation. Foreign packages and uncertain kernel/NVIDIA/boot/system packages are separate manual review lists. Build foreign recipes as a normal user only after reviewing their source and PKGBUILD; they are not assumed to be AUR packages.

## Your Zsh setup

The normal desktop restore command also restores `.zshrc`, `.p10k.zsh`, `.zprofile`, Oh My Zsh and Powerlevel10k to their original home-relative paths. Their source snapshots are bundled, so the restore does not fetch changing upstream versions or run the Oh My Zsh installer. The `git` plugin and your aliases are preserved. The system Zsh package, Git and your Kitty Nerd Font are in the prerequisite list.

Oh My Zsh is pinned to `4d4cfc287e9d887b81242c0e431b5f49f9cec5c1`; Powerlevel10k is pinned to `9253fb1c5034410c43a0c681ff8294181c54016c`. The existing Linux x86-64 gitstatus helper is bundled with its checksum. Git metadata is omitted, so framework/theme Git-based updates need a separately reviewed checkout later. Two unused plugin demo GIFs were omitted. One example token in upstream documentation was redacted; active runtime settings were preserved, with your absolute home path templated for the new username.

Your `.zprofile` starts `uwsm start hyprland.desktop` on the configured TTYs when its readiness checks pass. Review this if the new install uses a display manager or another session arrangement. The restore does not change your account's login shell. Kitty already selects `zsh`; to make it your login shell too, run this **on the new installation**, then log out and back in:

```bash
chsh -s /usr/bin/zsh
```

Open a new terminal to verify the prompt, colors, icons and Git status. Shell history, completion dumps, instant-prompt caches and credentials are excluded from GitHub. Aliases are preserved exactly, including aliases for `dust` and `nitch`, which were not found on the current command PATH; these commands need separate review if you want to use them. Aliases for `paru` require the separately reviewed foreign-package helper.

## Your Neovim / NvChad setup

All 13 current non-Git files under `.config/nvim` are included, including `init.lua`, Lua settings/mappings/plugin specifications and `lazy-lock.json`. The lockfile records 27 plugins, including NvChad v2.5. Its earlier snapshot differed only in whitespace/formatting; the same plugin revisions were already recorded. The Neovim package and Git are now in the prerequisite list.

Downloaded upstream plugin repositories are recreated over the network. After the normal desktop restore, open `nvim`, let the bootstrap finish, and run:

```vim
:Lazy restore
```

This restores the plugin revisions in the saved lockfile ([lazy.nvim lockfile documentation](https://lazy.folke.io/usage/lockfile)). Close Neovim when it completes. Your current setup also has 23 custom files inside downloaded plugins: an Island theme-sync module, its startup hook and 21 Base46 themes. These are preserved separately under `nvim-overrides/`, so they do not create partial plugin directories before Lazy installs the plugins. From this checkout, run:

```bash
python3 scripts/restore-nvim-overrides.py --dry-run
python3 scripts/restore-nvim-overrides.py --apply
```

The script checks source hashes, plugin Git revisions and the restored lockfile before copying additions back to their original `.local/share/nvim/lazy/NvChad/` and `base46/` locations. It skips identical files and backs up conflicts. Reopen Neovim and check `:IslandThemeReload`, the theme picker and desktop theme synchronization. Base46 compiled caches regenerate; they are not copied from the old installation. Reapply additions after plugin updates only after reviewing compatibility.

Private undo history, ShaDa, swap files, recovery backups and logs are not public dotfiles. Keep them in the private backup if needed, especially unsaved editing work. The current config references `stylua` and the HTML language server, but neither command was found on the current PATH; the CSS language server is present. These pre-existing tool gaps need separate review. Plugin downloads/builds, language-server availability and the restored editor still require a live check.

## VSCodium theme synchronization

ZuriTheme 0.0.2 includes its activation entrypoint, Island file watcher and palette-generation JavaScript, alongside all bundled theme assets. `zuritheme.syncWithIsland` is explicitly enabled in the restored VSCodium settings. On startup, the extension reads `~/.config/island-shell/theme-state.json` (or the equivalent under `XDG_CONFIG_HOME`) and selects the matching editor theme. While the editor is open, it watches for Island theme changes and updates automatically. Material You uses the shared dynamic palette too.

The normal desktop restore includes these files; reopen VSCodium afterward. Check that ZuriTheme is enabled, then switch the desktop theme with Super+T. If needed, run **ZuriTheme: Sync with Island** from the command palette. An extension setting or an overriding workspace/profile preference can affect the result. The synchronization logic was checked with a simulated editor and temporary state files, including an atomic state-file replacement; the restored graphical editor still needs a live check.

## Important limits

- Quickshell provides the notification server, popups and notification history. SwayNC is excluded from both reinstall lists. Its old configuration remains in the snapshot for reference but is not autostarted by the included Hyprland configuration. On the new installation, check that another notification daemon is not started by the installer or session.

- Python is a runtime requirement for this custom shell and retained apps. Optional Python development tools and Docker were excluded, not required runtime dependencies.
- `cliphist`, `matugen` and `python-libsass` are explicit prerequisites in place of old machine-specific binaries. A future version may change command-line/API compatibility. Vendored `_sass`/mprisence binaries were not uploaded. Optional browser media bridging requires a separately reviewed trusted mprisence installation; ordinary MPRIS media support remains in the source.
- The matching selected Colloid theme is included. Bibata cursors, Adwaita icons/fonts and Nerd fonts must be installed from the package lists or reviewed trusted packages. Fonts/themes from outside this snapshot are not silently assumed present.
- Dynamic Material You theme generation needs the bundled audited Sass/design sources and `python-libsass`; wallpapers and other personal images/audio are not included. Private runtime preferences/history are not recreated merely by copying `.config`.
- Only the ZuriTheme VSCodium extension is retained. Other extensions and their private state were excluded at your request. Browser profiles, game saves, passwords, all Codex data and personal projects belong in your private backup, not this public repository.
- New Hyprland/Qt/Quickshell versions may need configuration adaptation. Check launchers, notifications, locking/permission prompts, clipboard, screenshots, brightness, fonts/cursor, theme switching and prayer settings before relying on the desktop.

The snapshot was scanned for recognized credentials and private prayer values, including compressed asset contents. Syntax/checksum/path checks are distinct from a successful restore. No installation or desktop/private-state restoration was performed during preparation.
