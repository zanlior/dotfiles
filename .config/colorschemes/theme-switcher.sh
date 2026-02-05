#!/bin/bash

case "$1" in
    mocha)
        THEME="Colloid-Dark-mocha"
        ;;
    everforest)
        THEME="Colloid-Dark-Everforest"
        ;;
    tokyonight)
        THEME="Colloid-Dark-tokyo_night"
        ;;
    rxyhn)
        THEME="Colloid-Dark-rxyhn"
        ;;
    *)
        echo "Usage: $0 {mocha|everforest|tokyonight|rxyhn}"
        exit 1
        ;;
esac

# Copy theme file
cp ~/.config/colorschemes/${1}/waybar/colors.css ~/.config/waybar/colors/colors.css

# Copy rofi colors
cp ~/.config/colorschemes/${1}/rofi/colors.rasi ~/.local/share/rofi/themes/colors.rasi

# Copy hyprland colors
cp ~/.config/colorschemes/${1}/hypr/colors.conf ~/.config/hypr/colors/colors.conf

# Copy kitty colors
cp ~/.config/colorschemes/${1}/kitty/colors.conf ~/.config/kitty/colors.conf
# Apply GTK theme
gsettings set org.gnome.desktop.interface gtk-theme "$THEME"

# Reload waybar
pkill -SIGUSR2 waybar

# Reload hyprland
hyprctl reload

# Reload kitty 
killall -SIGUSR1 kitty

echo "Theme switched to: $1"
