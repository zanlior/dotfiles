# Retained applications needing a separate Fedora/upstream source

These are **Keep**, not omitted or silently replaced. `restore-apps.py` reports this entire list. It installs only `fedora-apps.txt`. Review downloads, publishers, signatures, dependencies and update routes before installing. Do not reuse Arch package archives or binaries linked against Arch libraries.

| Original selection | Fedora route / remaining review |
| --- | --- |
| Brave Origin (`brave-origin-bin`) | Confirm the exact Origin product/channel and Linux RPM availability with [Brave](https://brave.com/linux/). Standard Brave is an alternative, not an automatic replacement. Adjust the browser keybinding to the installed command if necessary. |
| Zen (`zen-browser-bin`) | [Zen upstream](https://zen-browser.app/download/) Linux tarball or its documented Flatpak; if sandboxed, change Super+W to the actual launcher. Keep the private browser profile separately. |
| ChatGPT desktop wrapper (`chatgpt-desktop-bin`) | Original wrapper publisher remains unverified. Review the [official Linux app](https://learn.chatgpt.com/docs/linux/linux-app) as an alternative; this script does not install or substitute it. |
| IntelliJ IDEA Community | [JetBrains Linux distribution/Toolbox](https://www.jetbrains.com/help/idea/installation-guide.html); review current Community/free-feature packaging and required JDK. |
| Obsidian | [Upstream Linux AppImage](https://obsidian.md/download); existing vaults are private files. |
| OpenAI Codex | [Official Codex distribution](https://github.com/openai/codex), normal-user installation; restore private `.codex` and projects separately. Do not put auth in Git. |
| Proton Mail | [Official RPM instructions](https://proton.me/support/set-up-proton-mail-linux). Reauthentication and current Linux support conditions require review. |
| Proton Pass | [Official RPM instructions](https://proton.me/support/set-up-proton-pass-linux). Preserve account recovery credentials privately; expect reauthentication. |
| Vesktop | [Upstream releases](https://github.com/Vencord/Vesktop/releases), choose the current supported RPM/AppImage; verify publisher. |
| VSCodium | [Native upstream RPM/repository](https://vscodium.com/#install). Use native `codium` for the saved `.config/VSCodium` and `.vscode-oss` paths; Flatpak requires separate path/permission adaptation. Only ZuriTheme is retained. |
| Aseprite | [Upstream Linux build/download](https://www.aseprite.org/download/), review licensing or normal-user source build. Original foreign package origin was not verified. |
| Artcraft Launcher | [Publisher site](https://www.artcraft.ai/); confirm current Linux format and exact publisher against your existing launcher before executing a download. |
| Bedrock on Linux | [Original project](https://github.com/wyze3306/bedrock-on-linux), review its current Linux/Fedora release and prerequisites; do not confuse it with another Bedrock launcher. |
| OBS PipeWire audio capture | [Plugin upstream](https://github.com/dimtpap/obs-pipewire-audio-capture); choose a build matching Fedora's OBS ABI, or review a normal-user source build. |
| Java 8 (`jre8`) | Review which retained game/instance needs it. Use the launcher's supported Java management or a reviewed Fedora/upstream Java 8 build. Do not overwrite the default Java runtime. |
| CSS language server | [VS Code extracted language servers](https://github.com/hrsh7th/vscode-langservers-extracted). Optional normal-user npm prefix provides `vscode-css-language-server` and HTML support; avoid `sudo npm`. These and Stylua were existing editor tool gaps. |
| Geist Mono Nerd, JetBrains Mono Nerd, Inter, Rubik, Bibata | See the font/cursor step in `FEDORA.md`. Exact families matter; ordinary JetBrains Mono lacks Nerd glyphs. |
| Seven Craft AppImages | Restore PDFcraft, Wordcraft, Photocraft, Filmcraft, Deckcraft, Gridcraft and Soundcraft under `~/Applications` from your private backup. The included desktop entries expect those paths/versioned filenames. Inspect compatibility, publisher/signatures and FUSE requirements first. |
| `python-skia-pathops`, `ttfautohint` | Old foreign dependency-review items. Re-evaluate only if a retained source/font build needs them; not standalone apps to force onto Fedora. |
| `paru` | Arch-only helper is unnecessary on Fedora; its old inventory record remains for completeness. COPR trust/source review is separate from AUR/PKGBUILD review. |
| Optional `dust`, `nitch` aliases | Already missing on the original PATH. Install only from a reviewed Fedora/upstream source if wanted; these are not required for the prompt. |

Excluded selections remain KeePassXC, Ollama CUDA, OnlineFix Linux Launcher, optional Python development tooling, Docker/Compose, Waybar, rofi, feh, Claude, Hamlet app and OmniRoute. Python needed by the rice remains required. Possible Codex/Hamlet shared workspace state remains in the private backup scope. Browser profiles, game saves, databases and account state are not public dotfiles.

`review/`, `packages/original-pacman.tsv` and `packages/desktop-required.txt` preserve the original CachyOS evidence and choices. They are **historical inputs**, not Fedora installation lists. The new entrypoints never feed those Arch names to DNF. Kernel, NVIDIA, boot, filesystem, encryption, printing and Secure Boot decisions are made against the new Fedora installation, not copied from the old machine.
