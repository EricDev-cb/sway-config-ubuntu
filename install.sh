#!/usr/bin/env bash

#!/usr/bin/env bash

# Safe Ubuntu/Debian Sway Installer
# Adaptado de rice Arch para Ubuntu
# NÃO remove GNOME/GDM
# NÃO mexe em boot crítico
# NÃO usa AUR/pacman

set -e

clear

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
NC="\033[0m"

REPO="https://github.com/harilvfs/swaydotfiles"
DOTFILES_DIR="$HOME/swaydotfiles"
BACKUP_DIR="$HOME/.config.backup.$(date +%s)"

print() {
    echo -e "${1}${2}${NC}"
}

# ----------------------------
# Detect Ubuntu/Debian
# ----------------------------

if ! command -v apt >/dev/null 2>&1; then
    print "$RED" "Este script suporta apenas Ubuntu/Debian."
    exit 1
fi

print "$GREEN" "Ubuntu/Debian detectado."

# ----------------------------
# Packages
# ----------------------------

PACKAGES=(
    sway
    swaybg
    swayidle
    swaylock
    waybar
    rofi
    mako-notifier
    kitty
    foot
    wl-clipboard
    grim
    slurp
    swappy
    network-manager-gnome
    pavucontrol
    playerctl
    brightnessctl
    pipewire
    wireplumber
    xdg-desktop-portal-wlr
    fonts-font-awesome
    fonts-noto
    fonts-noto-cjk
    fonts-noto-color-emoji
    git
    curl
)

print "$CYAN" "Atualizando repositórios..."
sudo apt update

print "$CYAN" "Instalando dependências..."
sudo apt install -y "${PACKAGES[@]}"

# ----------------------------
# Backup
# ----------------------------

print "$YELLOW" "Criando backup da ~/.config"

mkdir -p "$BACKUP_DIR"

for dir in sway waybar mako kitty foot rofi; do
    if [ -d "$HOME/.config/$dir" ]; then
        mv "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
done

print "$GREEN" "Backup salvo em:"
echo "$BACKUP_DIR"

# ----------------------------
# Clone dotfiles
# ----------------------------

if [ -d "$DOTFILES_DIR" ]; then
    print "$YELLOW" "Diretório swaydotfiles já existe."
else
    print "$CYAN" "Clonando dotfiles..."
    git clone "$REPO" "$DOTFILES_DIR"
fi

# ----------------------------
# Copy safe configs only
# ----------------------------

mkdir -p "$HOME/.config"

SAFE_CONFIGS=(
    sway
    waybar
    mako
    kitty
    foot
    rofi
)

for cfg in "${SAFE_CONFIGS[@]}"; do
    if [ -d "$DOTFILES_DIR/$cfg" ]; then
        print "$GREEN" "Copiando $cfg"
        cp -r "$DOTFILES_DIR/$cfg" "$HOME/.config/"
    fi
done

# ----------------------------
# Wallpaper dir
# ----------------------------

mkdir -p "$HOME/Pictures/wallpapers"

# ----------------------------
# Permissions
# ----------------------------

chmod -R +x "$HOME/.config/sway" 2>/dev/null || true

# ----------------------------
# Final
# ----------------------------

print "$GREEN" "Instalação concluída com segurança."

echo
print "$CYAN" "O que ESTE script NÃO faz:"
echo "- NÃO remove GDM"
echo "- NÃO remove GNOME"
echo "- NÃO instala SDDM"
echo "- NÃO mexe em boot"
echo "- NÃO usa pacman"
echo "- NÃO usa AUR"
echo

print "$CYAN" "Para iniciar o Sway:"
echo "1. Reinicie"
echo "2. Tela de login"
echo "3. Clique na engrenagem ⚙️"
echo "4. Escolha sessão Sway"

echo
print "$GREEN" "Tudo pronto."