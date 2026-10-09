# Aliases. Sourced by ~/.bashrc.

# CPU / GPU
alias gpu="~/.config/waybar/scripts/gpu_stats.sh -v"
alias gpuwatch="watch -n1 ~/.config/waybar/scripts/gpu_stats.sh -v"
alias temps="watch -n1 sensors k10temp-pci-00c3 amdgpu-pci-2b00"

# Fish
alias fish='asciiquarium'

# Change the kitty theme
alias theme='kitty +kitten themes'

# File operations
alias cp='cp -i'
alias mv='mv -i' # -i for interactive (means it will ask before overwriting)
alias rsyncp='rsync -ah --info=progress2'

# Update the wallpaper 
alias update_wallpaper="pkill hyprpaper && hyprpaper &"

# bluetooth connect
earbuds_mac="E8:26:CF:D4:4D:A0"
alias connect_earbuds="bluetoothctl connect $earbuds_mac"
alias disconnect_earbuds="bluetoothctl disconnect $earbuds_mac"

# General
alias sp='sudo pacman'
# Update system
alias upd="sudo pacman -Syu"
# Install a package
alias in="sudo pacman -S"
# Remove a package (and dependencies)
alias rem="sudo pacman -Rns"
# Search in repos
alias ss="pacman -Ss"
# Search installed packages
alias qs="pacman -Qs"
# List explicitly installed packages
alias lspkg="pacman -Qe"
# Clean package cache
alias clean="sudo pacman -Sc"
# Show info about a package
alias info="pacman -Qi"
# List orphaned packages
alias orphans="pacman -Qtdq"
# Remove orphans
alias rmo="sudo pacman -Rns \$(pacman -Qtdq)"

alias 'cd..'='cd ..'
alias 'cd...'='cd ../..'
alias 'cd....'='cd ../../..'
alias 'cd.....'='cd ../../../..'
alias bd='cd "$OLDPWD"'

# Listing
alias ls='eza --icons --group-directories-first --header --color=always --git'
alias la='eza --icons --group-directories-first --header --color=always --git --all'
alias ll='eza --icons --long --group-directories-first --header --color=always --git --no-permissions --no-user'

# Useful utilities
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'

# System information
alias ver='ver'
alias netinfo='netinfo'
alias openports='netstat -nape --inet'
alias distribution='distribution'

# Reboot
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Disk usage
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Logs
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e 's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

#######################################################
# ALIASES: PROGRAMMING AND DEV TOOLS
#######################################################
# Git
alias ga='git add .'
alias gc='git commit -m "Default Message"'
alias gp='git push'
alias gb='git branch'
alias gf='git fetch'
alias gm='git merge'
alias gd='git diff HEAD^ HEAD'
alias gdd='git diff --cached'
alias lg='git log --graph --oneline --decorate --all'
# Python and venv
alias python='python3'
alias pip='pip3'
alias ave='source .venv/bin/activate'
alias dve='deactivate'

# esp-idf
alias esp='source /opt/esp-idf/export.sh'

# QMK
alias qmk_compile='qmk compile -kb crkbd/rev1 -km'

# ESP-IDF
alias get_idf='source /opt/esp-idf/export.sh'

# Custom scripts
alias start_server='python -m http.server 8000'
alias tmuxsetup='$HOME/.config/tmux/tmux-setup.sh'

# Neovim 
alias vim='nvim'

# Alias for kitty
alias pp="kitty @ set-font-size +1"
alias ppp="kitty @ set-font-size +2"
alias pppp="kitty @ set-font-size +3"
alias mm='kitty @ set-font-size -- -1'
alias mmm='kitty @ set-font-size -- -2'
alias mmmm='kitty @ set-font-size -- -3'
alias fnt="kitty @ set-font-size"

# Misc
alias lookingglass="~/looking-glass-B5.0.1/client/build/looking-glass-client -F"
alias weather='curl wttr.in/Halifax,Nova+Scotia'
