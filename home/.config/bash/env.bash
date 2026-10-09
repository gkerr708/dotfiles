# Environment: colours, library paths, tool settings. Sourced by ~/.bashrc.

export CLICOLOR=1
# Man page colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

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

# Batteries (upower object paths)
BAT0="/org/freedesktop/UPower/devices/battery_BAT0"
BAT1="/org/freedesktop/UPower/devices/battery_BAT1"

# nnn
# File where nnn writes the last directory on quit
#export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

# Start nnn in the current directory
export NNN_OPTS='dHi'

#Bookmarks: press ` key in nnn + the letter to jump
#export NNN_BMS="d:$HOME/Downloads,f:$HOME,.:$PWD,h:$HOME"

# lugin dir (clone https://github.com/jarun/nnn-plugins here)
#export NNN_PLUG="$HOME/.config/nnn/plugins"
export NNN_PLUG='p:preview-tui;f:finder;o:open-with'
