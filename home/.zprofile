# Fedora minimal: start Hyprland manually from a TTY until testing passes.
# Opt into the original TTY workflow only after testing login/recovery.
if [[ -o login && "${DOTFILES_HYPR_TTY_AUTOSTART:-0}" == 1 ]]; then
    case $(tty) in
        /dev/tty1|/dev/tty2)
            if command -v uwsm &>/dev/null && uwsm check may-start; then
                exec uwsm start hyprland.desktop
            fi
            ;;
    esac
fi
