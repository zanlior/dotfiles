if [[ -o login ]]; then
    case $(tty) in
        /dev/tty1|/dev/tty2)
            if command -v uwsm &>/dev/null && uwsm check may-start; then
                exec uwsm start hyprland.desktop
            fi
            ;;
    esac
fi
