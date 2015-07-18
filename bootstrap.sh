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

ok() {
    logging SUCCESS "$1"
}

die() {
    logging ERROR "$1" 1>&2
    exit 1
}

has() {
    type "$1" >/dev/null
    return $?
}

install_enhancd() {
    logging TITLE "== Bootstraping enhancd =="
    logging INFO "Installing dependencies..."

    has "git" || die "The installation requires the git command."

    if [ -z "$BASE" ]; then
        BASE="$HOME/.enhancd"
    fi

    if [ -z "$URL" ]; then
        URL="https://github.com/b4b4r07/enhancd"
    fi

    git clone "$URL" "$BASE"
    if [ $? -eq 0 ]; then
        ok "enhancd successfully installed."
        logging INFO 'Put something like this in the config file for your shell'
        logging INFO "source $BASE/enhancd.{,fi}sh"
    else
        die "Alas, enahancd failed to install correctly."
    fi
}

update_enhancd() {
    has "git" || die "The installation requires the git command."
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
        update_enhancd
        exit
    fi

    if [ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]; then
        trap "die 'terminated'; exit 1" INT ERR
        # -> cat a.sh | bash
        # -> bash -c "$(cat a.sh)"
        install_enhancd
    fi
fi
