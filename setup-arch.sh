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
    kitty
    hyprland
    hyprlock
    waybar
    wofi

    brightnessctl
    playerctl
    pipewire
    wireplumber
    bluez
    bluez-utils
    tmux
    rofi
    mpv
    imv                     # image viewer
    zathura                 # PDF viewer
    zathura-pdf-poppler     # PDF rendering backend for zathura (zathura alone can't open PDFs without this)
    btop

    base-devel              # provides fakeroot, required for makepkg
    debugedit               # required for makepkg debug package splitting
    nodejs                  # required for pyright and other Mason-managed LSP servers
    npm                     # required alongside nodejs for Mason installs (nvim-treesitter/Mason)
)

AUR_PKGS=(
    autojump-git
    tree-sitter-cli         # required by nvim-treesitter to compile parsers (newer versions shell out to the tree-sitter CLI binary instead of building parsers internally)
)

FONTS=(
    ttf-jetbrains-mono-nerd # JetBrainsMono Nerd Font (used by kitty)
)

# ── AUR helper bootstrap ────────────────────────────────────────────────────────
# yay itself must be built manually before any `yay -S` (AUR_PKGS) calls will work.

ensure_yay() {
    if command -v yay &>/dev/null; then
        return
    fi

    echo -e "${YELLOW}yay not found — bootstrapping yay-bin from AUR...${RC}"
    local tmp_dir
    tmp_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay-bin"
    (cd "$tmp_dir/yay-bin" && makepkg -si)
    rm -rf "$tmp_dir"
}

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
        "$HOME/.config/btop" \
        "$HOME/.config/git" \
        "$HOME/.config/hypr" \
        "$HOME/.config/kitty" \
        "$HOME/.config/matplotlib/stylelib" \
        "$HOME/.config/mpv" \
        "$HOME/.config/rofi" \
        "$HOME/.config/tmux" \
        "$HOME/.config/wofi"

    stow home
    echo -e "${GREEN}Dotfiles linked.${RC}"
}

# ── Main ──────────────────────────────────────────────────────────────────────

ensure_yay
check_packages
link_dotfiles

echo -e "${GREEN}Done! Open a new shell to see your config.${RC}"
