# Overrides grep command
__enhancd::command::grep()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
        shift
    else
        cat <&0
    fi \
        | command grep -E "$@" 2>/dev/null
}

# Returns true if the argument exists in PATH such as "which" command
__enhancd::command::which()
{
    if [[ -z $1 ]]; then
        return 1
    fi

    type "$1" >/dev/null 2>&1
    return $?
}

# Returns gawk if found, else awk
__enhancd::command::awk()
{
    if type gawk &>/dev/null; then
        gawk ${1:+"${@}"}
    else
        awk ${1:+"${@}"}
    fi
}
