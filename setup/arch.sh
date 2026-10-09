#!/bin/bash
# Bootstrap a fresh Arch install: install packages, link dotfiles, enable services.
# Safe to re-run — every step is idempotent.

set -euo pipefail

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

DOTFILES_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

# ── Packages ──────────────────────────────────────────────────────────────────

PACMAN_PKGS=(
    # Core / build
    base-devel              # provides fakeroot, required for makepkg
    debugedit               # required for makepkg debug package splitting
    git
    stow
    cmake                   # nvim <leader> C++ build mapping
    unzip                   # Mason extracts LSP archives
    7zip
    unarchiver              # `unar`, yazi extract opener
    strace                  # cpp() in .bashrc
    net-tools               # `openports` alias (netstat)
    bash-completion
    wl-clipboard            # nvim system clipboard on Wayland
    mangohud                # game FPS/CPU/GPU overlay
    lib32-mangohud          # needs multilib enabled

    # Shell / CLI
    neovim
    bat
    ripgrep
    fd                      # nvim sqlite picker, telescope
    fzf                     # tmux-fzf
    eza                     # ls aliases
    zoxide
    starship
    git-delta
    fastfetch
    tree
    btop
    tmux
    yazi
    visidata                # `vd`, used by nvim + yazi
    sqlite
    jq
    shellcheck              # lint scripts in setup/, ~/.local/bin, waybar/scripts
    ffmpegthumbnailer       # yazi video previews
    poppler                 # yazi PDF previews
    imagemagick             # yazi image previews (+ wallpaper generation below)
    resvg                   # yazi SVG previews
    asciiquarium            # `fish` alias
    speedtest-cli
    chrony

    # Languages / dev
    nodejs                  # required for pyright, copilot, markdown-preview
    npm
    python
    python-pip
    uv
    rustup
    lua-language-server
    luarocks                # lazy.nvim rocks support
    tree-sitter-cli         # nvim-treesitter compiles parsers with this
    r                       # R.nvim

    # LaTeX (vimtex + latexmk + zathura)
    texlive-basic
    texlive-binextra        # latexmk
    texlive-latexextra
    texlive-fontsrecommended
    biber

    # Desktop (Hyprland)
    hyprland
    hyprlock
    hyprpaper
    hyprpolkitagent
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    waybar
    wofi
    rofi
    kitty
    network-manager-applet  # nm-applet (autostart)
    brightnessctl
    playerctl
    pipewire
    wireplumber
    pavucontrol             # waybar audio click
    wiremix                 # SUPER+E
    bluez
    bluez-utils
    blueman                 # waybar bluetooth click

    # Apps
    firefox
    mpv
    imv                     # image viewer
    zathura                 # PDF viewer
    zathura-pdf-poppler     # PDF rendering backend for zathura (zathura alone can't open PDFs without this)
    libreoffice-fresh       # .docx in mimeapps / yazi
    ncspot
    spotify-player

    # Fonts
    ttf-jetbrains-mono-nerd # JetBrainsMono Nerd Font (used by kitty)
    noto-fonts
    noto-fonts-emoji
)

AUR_PKGS=(
    autojump-git
    grimblast-git           # screenshots
    nchat-git               # terminal WhatsApp/Telegram client
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
    (cd "$tmp_dir/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp_dir"
}

install_packages() {
    echo -e "${YELLOW}Installing pacman packages...${RC}"
    sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

    ensure_yay

    echo -e "${YELLOW}Installing AUR packages...${RC}"
    yay -S --needed --noconfirm "${AUR_PKGS[@]}"
    echo -e "${GREEN}Packages installed.${RC}"
    echo
}

# ── Symlinks via stow ─────────────────────────────────────────────────────────

# Move any real file that would block stow to <file>.bak (ignored by git).
backup_conflicts() {
    local rel target
    while IFS= read -r rel; do
        rel="${rel#home/}"
        target="$HOME/$rel"
        if [[ -e "$target" && ! -L "$target" ]] && [[ -f "$target" ]]; then
            echo -e "  ${YELLOW}[backup]${RC} ~/$rel -> ~/$rel.bak"
            mv "$target" "$target.bak"
        fi
    done < <(cd "$DOTFILES_DIR" && find home -type f -o -type l)
}

link_dotfiles() {
    echo -e "${YELLOW}Linking dotfiles with stow...${RC}"
    cd "$DOTFILES_DIR"

    backup_conflicts

    # Real dirs so stow links files inside them instead of folding the whole dir
    # into the repo (other tools write to ~/.local/bin and ~/.config/systemd/user).
    mkdir -p \
        "$HOME/.local/bin" \
        "$HOME/.config/systemd/user" \
        "$HOME/.config/btop" \
        "$HOME/.config/git" \
        "$HOME/.config/hypr" \
        "$HOME/.config/kitty" \
        "$HOME/.config/matplotlib/stylelib" \
        "$HOME/.config/mpv" \
        "$HOME/.config/ripgrep" \
        "$HOME/.config/rofi" \
        "$HOME/.config/spotify-player" \
        "$HOME/.config/tmux" \
        "$HOME/.config/wofi"

    stow --restow home
    echo -e "${GREEN}Dotfiles linked.${RC}"
    echo
}

# ── Post-install setup ────────────────────────────────────────────────────────

setup_extras() {
    echo -e "${YELLOW}Post-install setup...${RC}"

    # tmux plugin manager (plugins/ is gitignored)
    local tpm="$HOME/.config/tmux/plugins/tpm"
    if [[ ! -d "$tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$tpm"
    fi
    "$tpm/bin/install_plugins" || true

    # Rust toolchain (rust_analyzer via Mason expects cargo)
    if ! rustup toolchain list | grep -q stable; then
        rustup default stable
    fi

    # npm global prefix from .npmrc
    mkdir -p "$HOME/.npm-global"

    # Wallpaper referenced in hypr/variables.lua
    if [[ ! -f "$HOME/images/black.png" ]]; then
        mkdir -p "$HOME/images"
        magick -size 16x16 xc:black "$HOME/images/black.png"
    fi

    # Services
    sudo systemctl enable --now NetworkManager
    sudo systemctl enable --now bluetooth
    sudo systemctl disable --now systemd-timesyncd 2>/dev/null || true  # conflicts with chrony
    sudo systemctl enable --now chronyd

    # Neovim plugins (lazy.nvim bootstraps itself; Mason installs LSPs on first open)
    nvim --headless "+Lazy! sync" +qa || true

    echo -e "${GREEN}Extras done.${RC}"
    echo
}

# ── Main ──────────────────────────────────────────────────────────────────────

install_packages
link_dotfiles
setup_extras

echo -e "${GREEN}Done! Open a new shell (or log into Hyprland) to see your config.${RC}"
