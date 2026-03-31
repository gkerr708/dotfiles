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
    git-delta
    alacritty
    kitty
    hyprland
    hyprlock
    waybar
    wofi

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

check_packages() {
    echo -e "${YELLOW}Package checklist:${RC}"

    local all_good=true

    for pkg in "${PACMAN_PKGS[@]}" "${FONTS[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null || command -v "$pkg" &>/dev/null; then
            echo -e "  ${GREEN}[✓]${RC} $pkg"
        else
            echo -e "  ${RED}[✗]${RC} $pkg  (install: sudo pacman -S $pkg)"
            all_good=false
        fi
    done

    for pkg in "${AUR_PKGS[@]}"; do
        local cmd="${pkg%-bin}"; cmd="${cmd%-git}"
        if pacman -Qi "$pkg" &>/dev/null || command -v "$cmd" &>/dev/null; then
            echo -e "  ${GREEN}[✓]${RC} $pkg"
        else
            echo -e "  ${RED}[✗]${RC} $pkg  (install: yay -S $pkg)"
            all_good=false
        fi
    done

    if $all_good; then
        echo -e "${GREEN}All packages present.${RC}"
    else
        echo -e "${YELLOW}Install missing packages before continuing if needed.${RC}"
    fi
    echo
}

# ── Symlinks via stow ─────────────────────────────────────────────────────────

link_dotfiles() {
    echo -e "${YELLOW}Linking dotfiles with stow...${RC}"
    cd "$DOTFILES_DIR"

    # Check for conflicts before stowing
    local conflicts
    conflicts=$(stow --simulate home 2>&1 | grep "existing target is not" | sed 's/.*: //')

    if [[ -n "$conflicts" ]]; then
        echo -e "${RED}Conflicting files found (not symlinks):${RC}"
        while IFS= read -r f; do
            echo -e "  ${RED}[✗]${RC} ~/$f"
        done <<< "$conflicts"
        echo -e "${YELLOW}Remove or back up these files and re-run.${RC}"
        exit 1
    fi

    mkdir -p \
        "$HOME/.config/alacritty" \
        "$HOME/.config/btop" \
        "$HOME/.config/git" \
        "$HOME/.config/hypr" \
        "$HOME/.config/kitty" \
        "$HOME/.config/mpv" \
        "$HOME/.config/ranger" \
        "$HOME/.config/rofi" \
        "$HOME/.config/tmux" \
        "$HOME/.config/wofi"

    stow home
    echo -e "${GREEN}Dotfiles linked.${RC}"
}

# ── Main ──────────────────────────────────────────────────────────────────────

check_packages
link_dotfiles

echo -e "${GREEN}Done! Open a new shell to see your config.${RC}"
