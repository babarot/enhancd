__enhancd::custom::options::number()
{
    local num="${1#-}"

    if [[ ! $num =~ ^[0-9]+$ ]]; then
        __enhancd::utils::die \
            "$num: Is not numeric\n"
        return 1
    fi

    __enhancd::history::list \
        | head \
        | sed -n "$num"p \
        | __enhancd::cd
}
