# Overrides grep command
__enhancd::command::grep()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        command cat "$1"
        shift
    else
        command cat <&0
    fi \
        | command grep "$@" 2>/dev/null
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
        command awk ${1:+"${@}"}
    fi
}

# Reads lines from the named file or the standard input, writes the line
# with the numbering starting with 1 to the standard output such as nl command
__enhancd::command::nl()
{
    # d in awk's argument is a delimiter
    __enhancd::command::awk -v d="${1:-": "}" '
    BEGIN {
        i = 1
    }
    {
        print i d $0
        i++
    }' 2>/dev/null
}

__enhancd::command::run()
{
    local cond="${1}"
    ${SHELL:-bash} -c "${cond}" &>/dev/null
    return ${?}
}
