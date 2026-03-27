#######################################################
# SHELL MODE DETECTION
#######################################################
iatest=$(expr index "$-" i)


#######################################################
# CORE BASH CONFIGURATION
#######################################################
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi

# Expand history size
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTCONTROL=erasedups:ignoredups:ignorespace

# History appending
shopt -s histappend
PROMPT_COMMAND='history -a'

# Check terminal size
shopt -s checkwinsize

# Ignore ctrl-s freezing
[[ $- == *i* ]] && stty -ixon

# Case-insensitive autocompletion
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show autocomplete suggestions immediately
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Set default editors
export EDITOR=nvim
export VISUAL=nvim


#######################################################
# COLOR AND VISUAL SETTINGS
#######################################################
export CLICOLOR=1
export LS_COLORS='no=00:... (full LS_COLORS string)'
# Man page colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


#######################################################
# ENVIRONMENT VARIABLES FOR LIBRARIES AND TOOLS
#######################################################
# Pylon camera support
#export PYLON_ROOT=/opt/pylon
#export PYLON_INCLUDE=$PYLON_ROOT/include
#export PYLON_LIB=$PYLON_ROOT/lib
#export GENICAM_ROOT_V3_1=/opt/pylon/genicam
#export LD_LIBRARY_PATH=$PYLON_ROOT/lib64:$LD_LIBRARY_PATH
#export GENICAM_GENTL64_PATH=$PYLON_ROOT/lib64:$GENICAM_GENTL64_PATH
#export PATH=$PYLON_ROOT/bin:$PATH

# C++ config
#export LD_LIBRARY_PATH=/opt/pylon/lib:$LD_LIBRARY_PATH

# Add binaries to PATH
#export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"
# Load secrets (API keys, tokens — not tracked by git)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

export PATH="$HOME/.npm-global/bin:$PATH"

######################################################
# Fast fetch
######################################################
fastfetch

#######################################################
# ALIASES: SYSTEM AND UTILITIES
#######################################################

# Fish
alias fish='asciiquarium'

# Change the kitty theme
alias theme='kitty +kitten themes'

# File operations
alias cp='cp -i'
alias mv='mv -i' # -i for interactive (means it will ask before overwriting)
#alias rm='trash -v'

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
alias folderssort='find . -maxdepth 1 ...'
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
alias logs='sudo find /var/log ... | xargs tail -f'

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
alias lg='git log --graph ...'
gcm() { git add .; git commit -m "$1"; }
gg() { git add .; git commit -m "$1"; git push; }

# Python and venv
alias python='python3'
alias pip='pip3'
alias ave='source .venv/bin/activate'
alias dve='deactivate'

# QMK
alias qmk_compile='qmk compile -kb crkbd/rev1 -km'

# Custom scripts
alias start_server='python -m http.server 8000'
alias new_tex='$HOME/bash_scripts/new_tex.sh'
alias check_lab_repos='$HOME/bash_scripts/check_git_repos.sh'
alias tmux_help='$HOME/bash_scripts/tmux_help.sh'
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

#############
# nnn
############

# File where nnn writes the last directory on quit
#export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

# Start nnn in the current directory
export NNN_OPTS='dHi'

#Bookmarks: press ` key in nnn + the letter to jump
#export NNN_BMS="d:$HOME/Downloads,f:$HOME,.:$PWD,h:$HOME"

# lugin dir (clone https://github.com/jarun/nnn-plugins here)
#export NNN_PLUG="$HOME/.config/nnn/plugins"
export NNN_PLUG='p:preview-tui;f:finder;o:open-with'


#######################################################
# ZOXIDE + AUTOJUMP CONFIGURATION
#######################################################
_z_cd() {
    cd "$@" || return "$?"

    if [ "$_ZO_ECHO" = "1" ]; then
        echo "$PWD"
    fi
}

z() {
    if [ "$#" -eq 0 ]; then
        _z_cd ~
    elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
        if [ -n "$OLDPWD" ]; then
            _z_cd "$OLDPWD"
        else
            echo 'zoxide: $OLDPWD is not set'
            return 1
        fi
    else
        _zoxide_result="$(zoxide query -- "$@")" && _z_cd "$_zoxide_result"
    fi
}

zi() {
    _zoxide_result="$(zoxide query -i -- "$@")" && _z_cd "$_zoxide_result"
}

alias za='zoxide add'
alias zq='zoxide query'
alias zqi='zoxide query -i'

alias zr='zoxide remove'
zri() {
    _zoxide_result="$(zoxide query -i -- "$@")" && zoxide remove "$_zoxide_result"
}


_zoxide_hook() {
    if [ -z "${_ZO_PWD}" ]; then
        _ZO_PWD="${PWD}"
    elif [ "${_ZO_PWD}" != "${PWD}" ]; then
        _ZO_PWD="${PWD}"
        zoxide add "$(pwd -L)"
    fi
}

case "$PROMPT_COMMAND" in
    *_zoxide_hook*) ;;
    *) PROMPT_COMMAND="_zoxide_hook${PROMPT_COMMAND:+;${PROMPT_COMMAND}}" ;;
esac
alias lookingglass="~/looking-glass-B5.0.1/client/build/looking-glass-client -F"

if [ -f "/usr/share/autojump/autojump.sh" ]; then
	. /usr/share/autojump/autojump.sh
elif [ -f "/usr/share/autojump/autojump.bash" ]; then
	. /usr/share/autojump/autojump.bash
else
	echo "can't found the autojump script"
fi


#######################################################
# PROMPT
#######################################################
eval "$(starship init bash)"

#######################################################
# FUNCTIONS
#######################################################

# Change directory with ranger file chooser
r() {
    tmpfile="$(mktemp -t ranger_cd.XXXXXX)"
    ranger --choosedir="$tmpfile" "${@:-$(pwd)}"
    if [ -f "$tmpfile" ]; then
        dir="$(cat "$tmpfile")"
        rm -f "$tmpfile"
        [ -d "$dir" ] && cd "$dir"
    fi
}

# Extract various archive formats
extract () {
    for archive in "$@"; do
        if [ -f "$archive" ] ; then
            case $archive in
                *.tar.bz2)   tar xvjf $archive    ;;
                *.tar.gz)    tar xvzf $archive    ;;
                *.bz2)       bunzip2 $archive     ;;
                *.rar)       rar x $archive       ;;
                *.gz)        gunzip $archive      ;;
                *.tar)       tar xvf $archive     ;;
                *.tbz2)      tar xvjf $archive    ;;
                *.tgz)       tar xvzf $archive    ;;
                *.zip)       unzip $archive       ;;
                *.Z)         uncompress $archive  ;;
                *.7z)        7z x $archive        ;;
                *)           echo "don't know how to extract '$archive'..." ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

# Search for text in all files recursively
ftext () {
    grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
    | awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++) printf "="
            printf ">"
            for (i=percent;i<100;i++) printf " "
            printf "]\r"
        }
    } END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy file and cd into target dir if it exists
cpg () {
    if [ -d "$2" ];then
        cp "$1" "$2" && cd "$2"
    else
        cp "$1" "$2"
    fi
}

# Move file and cd into target dir if it exists
mvg () {
    if [ -d "$2" ];then
        mv "$1" "$2" && cd "$2"
    else
        mv "$1" "$2"
    fi
}

# Make dir and cd into it
mkdirg () {
    mkdir -p "$1"
    cd "$1"
}

# Go up N directories
up () {
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# Overridden cd with ls
cd () {
    if [ -n "$1" ]; then
        builtin cd "$@" && ls
    else
        builtin cd ~ && ls
    fi
}

# Show last two directories in PWD
pwdtail () {
    pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Detect distro
distribution () {
    local dtype="unknown"
    if [ -r /etc/rc.d/init.d/functions ]; then
        source /etc/rc.d/init.d/functions
        [ zz$(type -t passed 2>/dev/null) == "zzfunction" ] && dtype="redhat"
    elif [ -r /etc/rc.status ]; then
        source /etc/rc.status
        [ zz$(type -t rc_reset 2>/dev/null) == "zzfunction" ] && dtype="suse"
    elif [ -r /lib/lsb/init-functions ]; then
        source /lib/lsb/init-functions
        [ zz$(type -t log_begin_msg 2>/dev/null) == "zzfunction" ] && dtype="debian"
    elif [ -r /etc/init.d/functions.sh ]; then
        source /etc/init.d/functions.sh
        [ zz$(type -t ebegin 2>/dev/null) == "zzfunction" ] && dtype="gentoo"
    elif [ -s /etc/mandriva-release ]; then
        dtype="mandriva"
    elif [ -s /etc/slackware-version ]; then
        dtype="slackware"
    fi
    echo $dtype
}

# Show OS version info
ver () {
    local dtype=$(distribution)
    case $dtype in
        redhat)
            if [ -s /etc/redhat-release ]; then
                cat /etc/redhat-release && uname -a
            else
                cat /etc/issue && uname -a
            fi ;;
        suse)
            cat /etc/SuSE-release ;;
        debian)
            lsb_release -a ;;
        gentoo)
            cat /etc/gentoo-release ;;
        mandriva)
            cat /etc/mandriva-release ;;
        slackware)
            cat /etc/slackware-version ;;
        *)
            if [ -s /etc/issue ]; then
                cat /etc/issue
            else
                echo "Error: Unknown distribution"
                exit 1
            fi ;;
    esac
}

# Install packages depending on distro
install_bashrc_support () {
    local dtype=$(distribution)
    case $dtype in
        redhat) sudo yum install multitail tree joe ;;
        suse) sudo zypper install multitail tree joe ;;
        debian) sudo apt-get install multitail tree joe ;;
        gentoo) sudo emerge multitail tree joe ;;
        mandriva) sudo urpmi multitail tree joe ;;
        slackware) echo "No install support for Slackware" ;;
        *) echo "Unknown distribution" ;;
    esac
}

# Show network info
netinfo () {
    echo "--------------- Network Information ---------------"
    /sbin/ifconfig | awk /'inet addr/ {print $2}'
    echo ""
    /sbin/ifconfig | awk /'Bcast/ {print $3}'
    echo ""
    /sbin/ifconfig | awk /'inet addr/ {print $4}'
    /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
}

# Internal + external IP
whatsmyip () {
    if [ -e /sbin/ip ]; then
        echo -n "Internal IP: " ; /sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
    else
        echo -n "Internal IP: " ; /sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1} |' | awk '{print $2}'
    fi
    echo -n "External IP: " ; curl -s ifconfig.me
}

# Apache log viewer
apachelog () {
    if [ -f /etc/httpd/conf/httpd.conf ]; then
        cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
    else
        cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
    fi
}

# Apache config editor
apacheconfig () {
    if [ -f /etc/httpd/conf/httpd.conf ]; then
        sedit /etc/httpd/conf/httpd.conf
    elif [ -f /etc/apache2/apache2.conf ]; then
        sedit /etc/apache2/apache2.conf
    else
        echo "Error: Apache config file could not be found."
        echo "Searching for possible locations:"
        sudo updatedb && locate httpd.conf && locate apache2.conf
    fi
}

# PHP config editor
phpconfig () {
    if [ -f /etc/php.ini ]; then
        sedit /etc/php.ini
    elif [ -f /etc/php/php.ini ]; then
        sedit /etc/php/php.ini
    elif [ -f /etc/php5/php.ini ]; then
        sedit /etc/php5/php.ini
    elif [ -f /usr/bin/php5/bin/php.ini ]; then
        sedit /usr/bin/php5/bin/php.ini
    elif [ -f /etc/php5/apache2/php.ini ]; then
        sedit /etc/php5/apache2/php.ini
    else
        echo "Error: php.ini file could not be found."
        echo "Searching for possible locations:"
        sudo updatedb && locate php.ini
    fi
}

# MySQL config editor
mysqlconfig () {
    if [ -f /etc/my.cnf ]; then
        sedit /etc/my.cnf
    elif [ -f /etc/mysql/my.cnf ]; then
        sedit /etc/mysql/my.cnf
    elif [ -f /usr/local/etc/my.cnf ]; then
        sedit /usr/local/etc/my.cnf
    elif [ -f /usr/bin/mysql/my.cnf ]; then
        sedit /usr/bin/mysql/my.cnf
    elif [ -f ~/my.cnf ]; then
        sedit ~/my.cnf
    elif [ -f ~/.my.cnf ]; then
        sedit ~/.my.cnf
    else
        echo "Error: my.cnf file could not be found."
        echo "Searching for possible locations:"
        sudo updatedb && locate my.cnf
    fi
}

# Simple rot13
rot13 () {
    if [ $# -eq 0 ]; then
        tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    else
        echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    fi
}

# Trim whitespace
trim() {
    local var=$*
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}
