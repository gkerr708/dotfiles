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

# ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# Load secrets (API keys, tokens — not tracked by git)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# env.bash, aliases.bash, functions.bash
for f in "$HOME"/.config/bash/{env,aliases,functions}.bash; do
	[ -f "$f" ] && . "$f"
done
unset f

######################################################
# Fast fetch
######################################################
fastfetch

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

