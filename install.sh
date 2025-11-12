#!/bin/bash
set -e

PACMAN_PACKAGES="hyprland hyprpaper waybar rofi-wayland alacritty thunar firefox swaylock dunst polkit-kde-agent grim slurp ttf-noto-nerd"

AUR_PACKAGES="visual-studio-code-bin"

install_dependencies() {
    echo "-> Suche nach Paketmanager und installiere Abhängigkeiten..."

    if command -v pacman &> /dev/null; then
        echo "--> Arch Linux erkannt. Installiere mit pacman..."
        sudo pacman -Syu --noconfirm --needed $PACMAN_PACKAGES

        if command -v yay &> /dev/null; then
            yay -S --noconfirm --needed $AUR_PACKAGES
        elif command -v paru &> /dev/null; then
            paru -S --noconfirm --needed $AUR_PACKAGES
        else
            echo "--> Warnung: Kein AUR-Helper (yay/paru) gefunden. Bitte installiere $AUR_PACKAGES manuell."
        fi

    elif command -v apt &> /dev/null; then
        echo "--> Debian/Ubuntu erkannt. Installiere mit apt..."
        echo "!!! WICHTIG: Stelle sicher, dass du externe Repositories (z.B. für Hyprland) hinzugefügt hast!"
        sudo apt update
        sudo apt install -y $APT_PACKAGES

    elif command -v dnf &> /dev/null; then
        echo "--> Fedora erkannt. Installiere mit dnf..."
        echo "!!! WICHTIG: Stelle sicher, dass du externe Repositories (z.B. COPR für Hyprland) aktiviert hast!"
        sudo dnf install -y $DNF_PACKAGES
        
    else
        echo "--> Warnung: Konnte keinen unterstützten Paketmanager (pacman, apt, dnf) finden."
        echo "!!! Bitte installiere die benötigten Pakete manuell."
    fi
}

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
CONFIG_SOURCE_DIR="$SCRIPT_DIR/.config"
WALLPAPER_SOURCE_DIR="$SCRIPT_DIR/wallpapers"
CONFIG_DEST_DIR="$HOME/.config"
WALLPAPER_DEST_DIR="$HOME/Pictures"

echo "🚀 Starte die Konfiguration deines Systems..."

if [ -d "$CONFIG_SOURCE_DIR" ]; then
    echo "-> Kopiere Konfigurationsdateien nach $CONFIG_DEST_DIR..."
    cp -rv "$CONFIG_SOURCE_DIR"/* "$CONFIG_DEST_DIR/"
else
    echo "-> Warnung: Konfigurationsverzeichnis './config' nicht gefunden. Überspringe."
fi

if [ -d "$WALLPAPER_SOURCE_DIR" ]; then
    echo "-> Kopiere Wallpaper nach $WALLPAPER_DEST_DIR..."
    mkdir -p "$WALLPAPER_DEST_DIR"
    cp -rv "$WALLPAPER_SOURCE_DIR"/* "$WALLPAPER_DEST_DIR/"
else
    echo "-> Warnung: Wallpaper-Verzeichnis './wallpapers' nicht gefunden. Überspringe."
fi

