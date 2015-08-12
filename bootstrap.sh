#!/bin/bash
#
# Install dependencies and setup enhancd
#
# USAGE
#   ./bootstrap.sh
#   curl git.io/enahancd | sh

ink() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <color> <text>"
        echo "Colors:"
        echo "  black, white, red, green, yellow, blue, purple, cyan, gray"
        return 1
    fi

    local open="\033["
    local close="${open}0m"
    local black="0;30m"
    local red="1;31m"
    local green="1;32m"
    local yellow="1;33m"
    local blue="1;34m"
    local purple="1;35m"
    local cyan="1;36m"
    local gray="0;37m"
    local white="$close"

    local text="$1"
    local color="$close"

    if [ "$#" -eq 2 ]; then
        text="$2"
        case "$1" in
            black | red | green | yellow | \
                blue | purple | cyan | gray | white)
            eval color="\$$1"
            ;;
    esac
fi

printf "${open}${color}${text}${close}"
}

logging() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <fmt> <msg>"
        echo "Formatting Options:"
        echo "  TITLE, ERROR, WARN, INFO, SUCCESS"
        return 1
    fi

    local color=
    local text="$2"

    case "$1" in
        TITLE)
            color=yellow
            ;;
        ERROR | WARN)
            color=red
            ;;
        INFO)
            color=green
            ;;
        SUCCESS)
            color=green
            ;;
        *)
            text="$1"
    esac

    timestamp() {
        ink gray "["
        ink purple "$(date +%H:%M:%S)"
        ink gray "] "
    }

    timestamp; ink "$color" "$text"; echo
}

log_pass() {
    logging SUCCESS "$1"
}

log_fail() {
    logging ERROR "$1" 1>&2
}

log_info() {
    logging INFO "$1"
}

log_echo() {
    logging TITLE "$1"
}

has() {
    which "$1" >/dev/null 2>&1
    return $?
}

enhancd_download() {
    local tarball pd

    if [ -d "$PREFIX" ]; then
        log_fail "$PREFIX: old version already exists; remove that"
        exit 1
    fi

    if has "git"; then
        git clone -b "$BRANCH" "$URL" "$PREFIX"
    elif has "curl" || has "wget"; then
        # curl or wget
        local tarball="https://github.com/b4b4r07/enhancd/archive/${BRANCH}.tar.gz"
        if has "curl"; then
            curl -L "$tarball"

        elif has "wget"; then
            wget -O - "$tarball"

        fi | tar xv -

        # check if dir exists
        # e.g., PREFIX=~/non/exists/dir
        pd="$(dirname "$PREFIX")"
        if [ ! -d "$pd" ]; then
            mkdir -p "$pd"
        fi

        mv -f enhancd-$BRANCH "$PREFIX"

    else
        log_fail "curl or wget required"
        exit 1
    fi

    if [ -d "$PREFIX" ]; then
        log_pass "downloaded enhancd"
    else
        log_fail "something is wrong"
        exit 1
    fi
}

enhancd_install() {
    local path shell enhancd_sh config_file

    cd "$PREFIX" 2>/dev/null
    if [ ! -f enhancd.sh ]; then
        log_fail "something is wrong"
        exit 1
    fi

    shell="$(basename "$SHELL")"
    case "$shell" in
        bash)
            enhancd_sh="$PREFIX"/bash/enhancd.bash
            config_file=~/.bashrc
            ;;
        zsh)
            enhancd_sh="$PREFIX"/zsh/enhancd.zsh
            config_file=~/.zshrc
            ;;
        fish)
            enhancd_sh="$PREFIX"/fish/enhancd.fish
            config_file=~/.config/fish/config.fish
            ;;
        *)
            config_file="unknown"
            ;;
    esac

    if [ "$config_file" = "unknown" ]; then
        log_fail "enhancd supports only bash, zsh and fish"
        exit 1
    fi

    if [ "$BRANCH" = "v1" ]; then
        if [ "$shell" = "fish" ]; then
            log_fail "sorry, enhancd v1 does not support fish"
            exit 1
        fi
        config_file="$PREFIX"/enhancd.sh
    fi

    cat <<EOM >>"$config_file"
# enhancd
if [ -f "$enhancd_sh" ]; then
    source "$enhancd_sh"
fi
EOM

    if [ $? -eq 0 ]; then
        log_pass "installed enhancd"
    else
        log_info "Put something like this in $config_file"
        log_info "  source $enhancd_sh"
    fi

    log_info "Then, restart your shell to start enhancd!"
}

enhancd_main() {
    log_echo "== Bootstraping enhancd =="
    log_info "Installing dependencies..."
    echo

    if [ -z "$BRANCH" ]; then
        BRANCH="master"
    fi

    if [ -z "$PREFIX" ]; then
        PREFIX="$HOME/.enhancd"
    fi

    if [ -z "$URL" ]; then
        URL="https://github.com/b4b4r07/enhancd"
    fi

    if [ -d "$PREFIX" ]; then
        enhancd_update
        if [ $? -eq 0 ]; then
            exit 0
        else
            log_fail "couldn't update enhancd"
            exit 1
        fi
    fi

    enhancd_download
    enhancd_install

    log_pass "successfully completed the enhancd installation"
}

enhancd_update() {
    if ! has "git"; then
        log_fail "The installation requires the git command"
        exit 1
    fi

    if cd "$PREFIX" 2>/dev/null; then
        git pull origin master
        git submodule init
        git submodule update
        git submodule foreach git pull origin master
    else
        log_fail "something is wrong"
        exit 1
    fi
}

if echo "$-" | grep -q "i"; then
    # -> source a.sh
    return
else
    # three patterns
    # -> cat a.sh | bash
    # -> bash -c "$(cat a.sh)"
    # -> bash a.sh
    if [ "$0" = "${BASH_SOURCE:-}" ]; then
        # -> bash a.sh
        exit
    fi

    if [ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]; then
        trap "log_fail 'terminated $0'; exit 1" INT ERR
        # -> cat a.sh | bash
        # -> bash -c "$(cat a.sh)"
        enhancd_main
    fi
fi
