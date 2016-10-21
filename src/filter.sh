__enhancd::filter::exists()
{
    local line

    while read line
    do
        if [[ -d $line ]]; then
            echo "$line"
        fi
    done
}

# __enhancd::filter::unique uniques a stdin contents
__enhancd::filter::unique()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
    else
        cat <&0
    fi | awk '!a[$0]++' 2>/dev/null
}

# __enhancd::filter::reverse reverses a stdin contents
__enhancd::filter::reverse()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
    else
        cat <&0
    fi \
        | awk -f "$ENHANCD_ROOT/src/share/reverse.awk" \
        2>/dev/null
}
