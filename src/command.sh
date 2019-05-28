# Override grep command
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
