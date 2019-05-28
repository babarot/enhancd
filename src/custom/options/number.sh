__enhancd::custom::options::number()
{
    local num="${1#-}"

    if [[ ! $num =~ ^[0-9]+$ ]]; then
        echo "$num: Is not numeric" >&2
        return 1
    fi

    __enhancd::history::list \
        | head \
        | sed -n "$num"p \
        | __enhancd::cd
}
