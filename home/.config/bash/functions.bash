# Shell functions. Sourced by ~/.bashrc.

# Git: stage everything, show what was staged, then commit (gg also pushes)
gcm() { git add -A && git status --short && git commit -m "$1"; }
gg()  { git add -A && git status --short && git commit -m "$1" && git push; }

# Audo cd to cw with yazi
function r() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd "$cwd"
    fi
    rm -f "$tmp"
}

# Change directory with ranger file chooser
#r() {
#    tmpfile="$(mktemp -t ranger_cd.XXXXXX)"
#    ranger --choosedir="$tmpfile" "${@:-$(pwd)}"
#    if [ -f "$tmpfile" ]; then
#        dir="$(cat "$tmpfile")"
#        rm -f "$tmpfile"
#        [ -d "$dir" ] && cd "$dir"
#    fi
#}

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
