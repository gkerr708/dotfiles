#!/bin/bash

set -e

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

DOTFILES_DIR="$(dirname "$(realpath "$0")")"

# ── Packages ──────────────────────────────────────────────────────────────────

PACMAN_PKGS=(
    stow
    git
    neovim
    bat
    starship
    delta                  # git-delta
    alacritty
    kitty
    hyprland
    hyprlock
    waybar
    wofi
    nm-applet              # networkmanager-applet
    brightnessctl
    playerctl
    pipewire
    wireplumber
    tmux
    rofi
    mpv
    ranger
    btop
)

AUR_PKGS=(
    autojump-git
    awww-bin               # wallpaper daemon used in hyprland.conf
)

FONTS=(
    ttf-meslo-nerd         # MesloLGS Nerd Font (used by alacritty)
    ttf-jetbrains-mono-nerd # JetBrainsMono Nerd Font (used by kitty)
)

install_packages() {
    echo -e "${YELLOW}Installing pacman packages...${RC}"
    sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}" "${FONTS[@]}"

    if ! command -v yay &>/dev/null; then
        echo -e "${YELLOW}Installing yay...${RC}"
        sudo pacman -S --needed --noconfirm base-devel
        git clone https://aur.archlinux.org/yay-git.git /tmp/yay-git
        (cd /tmp/yay-git && makepkg --noconfirm -si)
        rm -rf /tmp/yay-git
    fi

    echo -e "${YELLOW}Installing AUR packages...${RC}"
    yay -S --needed --noconfirm "${AUR_PKGS[@]}"
}

# ── Symlinks via stow ─────────────────────────────────────────────────────────

link_dotfiles() {
    echo -e "${YELLOW}Linking dotfiles with stow...${RC}"
    cd "$DOTFILES_DIR"

    # Back up any existing real files that would conflict
    for f in \
        "$HOME/.bashrc" \
        "$HOME/.bash_profile" \
        "$HOME/.gitconfig" \
        "$HOME/.npmrc" \
        "$HOME/.config/starship.toml" \
        "$HOME/.config/alacritty/alacritty.toml" \
        "$HOME/.config/btop/btop.conf" \
        "$HOME/.config/git/ignore" \
        "$HOME/.config/hypr/hyprland.conf" \
        "$HOME/.config/hypr/hyprlock.conf" \
        "$HOME/.config/kitty/kitty.conf" \
        "$HOME/.config/kitty/current-theme.conf" \
        "$HOME/.config/kitty/mytheme.conf" \
        "$HOME/.config/mpv/mpv.conf" \
        "$HOME/.config/mpv/input.conf" \
        "$HOME/.config/rofi/config.rasi" \
        "$HOME/.config/tmux/tmux.conf"
    do
        if [[ -e "$f" && ! -L "$f" ]]; then
            echo -e "${YELLOW}Backing up $f → $f.bak${RC}"
            mv "$f" "$f.bak"
        fi
    done

    mkdir -p \
        "$HOME/.config/alacritty" \
        "$HOME/.config/btop" \
        "$HOME/.config/git" \
        "$HOME/.config/hypr" \
        "$HOME/.config/kitty" \
        "$HOME/.config/mpv" \
        "$HOME/.config/ranger" \
        "$HOME/.config/rofi" \
        "$HOME/.config/tmux"

    stow home
    echo -e "${GREEN}Dotfiles linked.${RC}"
}

# ── Main ──────────────────────────────────────────────────────────────────────

if ! groups | grep -q wheel; then
    echo -e "${RED}You must be in the wheel group to run this.${RC}"
    exit 1
fi

install_packages
link_dotfiles

echo -e "${GREEN}Done! Open a new shell to see your config.${RC}"
echo -e "${YELLOW}Note: edit ~/.config/hypr/hyprland.conf to set your monitor layout.${RC}"
