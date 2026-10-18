# Minimal Fedora → Hyprland + Island

This is your selected setup: a minimal Fedora base, Hyprland, the saved Quickshell rice and your retained applications. No GNOME/KDE desktop group, display manager, server role or configuration-management framework is required. Necessary GTK/Qt libraries, portals, system services and application dependencies still belong in the setup.

The kit is a restore/preparation kit, not a fully tested unattended operating-system installer. These commands are for the **new Fedora system only**, with a verified private backup/recovery route. No commands below were executed on the existing CachyOS machine during preparation.

## Installer choices

1. Download **Fedora Everything 44 Network Install ISO for Intel/AMD x86_64** from [Fedora's official download page](https://fedoraproject.org/misc/#everything). Verify its signed checksum. This is an online installer requiring working networking or a local repository mirror.
2. In **Software Selection**, choose **Minimal Install** and leave extra software groups unselected. Fedora's [minimal package-set test](https://fedoraproject.org/wiki/QA/TestCases/PackageSetsMinimalPackageInstall) describes selecting the minimal environment in the network/DVD installer. If the screen differs or no minimal option appears, check the ISO/release before proceeding.
3. Create your normal user with administrator/sudo access. Configure a working network connection and its autoconnect setting. Ethernet is convenient for the first boot; don't assume the minimal package selection includes every Wi-Fi component or firmware your adapter needs.
4. Use only the verified SSD as the installation target. Keep the HDD and its backup unchanged; incorporating it remains a separate post-install task. Inspect the actual Fedora installer partition proposal rather than applying the old CachyOS/Limine partition instructions.
5. The initial installed system boots to a **text login**. That is expected. Keep the installer/recovery USB and test a second console, such as Ctrl+Alt+F3, before launching graphics.

## First boot and bootstrap

Log in as your normal user. Confirm sudo works and that you have networking/DNS. These commands show status and do not ask you to disclose credentials:

```bash
cat /etc/fedora-release
nmcli general status
ip route
getent hosts github.com
```

If NetworkManager exists but is inactive, inspect its unit/status and, on this new installation, enable/start it if it is your chosen network manager. Do not run two network managers for the same interface. If networking, Wi-Fi firmware or sudo access is missing, resolve that before the remaining commands; installing the rice cannot recover a missing download connection automatically. `nmcli --ask device wifi connect "YOUR SSID"` prompts for a Wi-Fi secret without recording it in the command line; see the [NetworkManager examples](https://networkmanager.pages.freedesktop.org/NetworkManager/NetworkManager/nmcli-examples.html).

With working networking and sudo, review the transaction and install the small bootstrap set:

```bash
sudo dnf upgrade --refresh
sudo dnf --setopt=install_weak_deps=False install git python3 dnf5-plugins NetworkManager NetworkManager-tui ca-certificates curl tar xz
```

For a Wi-Fi adapter, additionally check/install `NetworkManager-wifi` and the appropriate Fedora firmware package; don't add arbitrary firmware bundles without identifying the adapter. `dnf5-plugins` supplies the [COPR command](https://packages.fedoraproject.org/pkgs/dnf5/dnf5-plugins/). No desktop environment is installed by this bootstrap command. If the kernel changed, finish updates and reboot before setting up the matching NVIDIA module.

Clone the kit as your normal user, choosing an unused destination:

```bash
git clone --branch fedora --single-branch https://github.com/zanlior/dotfiles.git "$HOME/dotfiles-fedora"
cd "$HOME/dotfiles-fedora"
sha256sum -c SHA256SUMS
```

Continue **FEDORA.md sections 1 and 3–6**: current NVIDIA setup for your RTX 3060, reviewed community package sources, exact fonts/cursor, dependency dry-run/apply, configuration preview/apply, private settings and retained applications. The original application Keep/Exclude decisions remain; this minimal-base preference does not silently exclude apps you previously kept. The scripts never install GNOME/KDE groups or a display manager.

## Services and session readiness

Minimal Install does not provide the same configured desktop service baseline as Workstation. Review the installed units on the new system before the first graphical session:

- Networking: NetworkManager must manage the intended connection; `NetworkManager-tui` provides `nmtui` without a graphical desktop.
- Audio: PipeWire, its PulseAudio compatibility sockets and WirePlumber must be available to your user. Inspect `systemctl --user status pipewire.socket pipewire-pulse.socket wireplumber.service`; use Fedora's package presets or enable/start the intended user units if absent. Do not add a second PulseAudio server.
- D-Bus/polkit: Fedora's system D-Bus and polkit units must be functional. The saved Island setting has its built-in polkit agent disabled. After starting Hyprland, inspect/start the packaged `hyprpolkitagent` user service so permission dialogs work. Keep one polkit agent; if you choose Island's built-in agent later, review the external agent accordingly.
- Bluetooth: if you use it, inspect the `bluetooth.service` unit and enable/start it on the new system after installing the mapped BlueZ package. A missing adapter or firmware needs a hardware check.
- Screen sharing/file pickers: the mapped Hyprland/GTK portals need the correct Hyprland session environment. UWSM provides session environment/lifecycle integration; test the actual portal operations after login.
- DDC/brightness and locking: review Fedora's device permissions and the packaged Hyprlock PAM setup on the new machine. No old device permissions or PAM files are copied. Do not disable SELinux or grant blanket device access to make these pass.

These are manual new-system service checks; the restore scripts deliberately do not enable services or assume the host's current state. GTK/Qt support libraries do not mean GNOME/KDE desktops have been installed.

## Start Hyprland without a display manager

Once the prerequisites and restore checks pass, log into a **local text console as your normal user**, not root or an SSH session. Keep another console available for recovery. Launch the session using the [upstream UWSM route](https://wiki.hypr.land/Useful-Utilities/Systemd-start/):

```bash
uwsm check may-start
uwsm start hyprland.desktop
```

Run the second command only if the readiness check succeeds. Your Hyprland config starts Island/Quickshell and the wallpaper daemon. No GDM or SDDM is needed. The shipped `.zprofile` does not automatically start graphics until you opt in, allowing you to reach a console if the rice fails. Optional TTY autostart is already guarded by `DOTFILES_HYPR_TTY_AUTOSTART=1`; enable it only after successful manual launches and review your login shell separately.

TTY login can have different keyring-unlock behavior from a display manager. The kit does not modify Fedora PAM automatically. Password-manager/browser/Proton applications may need reauthentication or a separately configured user secret service. Keep recovery credentials private and available.

Validate the complete session with FEDORA.md's final checks, including graphics/Minecraft, audio, networking, notifications, locking, theme switching, clipboard and editor synchronization. If it fails, return to the working console, inspect logs and repair that component; no extra desktop environment or reinstall is required merely to diagnose it. This minimal graphical setup remains **untested on a real Fedora host**.
