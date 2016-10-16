__enhancd::arguments::option()
{
    local opt="$1" action
    shift

    __enhancd::utils::die \
        "$opt: no such option\n"
    return 1

    action="$(
    "$ENHANCD_ROOT/.bin/json.sh" \
        "$ENHANCD_ROOT/custom.json" \
        | awk -v opt="$opt" '
            $2 == opt{
                sub(/\.(short|long$)/, "", $1)
                act = $1 ".action";
            }
            $1 == act{
                $1 = "";
                print $0;
            }'
    )"

    if [[ -z $action ]]; then
        __enhancd::utils::die \
            "$opt: no such option\n"
        return 1
    fi

    eval "$action $@"
}

__enhancd::arguments::hyphen()
{
    if [[ $ENHANCD_DISABLE_HYPHEN == 1 ]]; then
        echo "$OLDPWD"
        return 0
    fi

    __enhancd::list "$1" | head | __enhancd::filter
}

__enhancd::arguments::dot()
{
    if [[ $ENHANCD_DISABLE_DOT == 1 ]]; then
        echo ".."
        return 0
    fi

    __enhancd::path::go_upstairs "$PWD" \
        | __enhancd::utils::reverse \
        | command grep "$1" \
        | __enhancd::filter \
        | __enhancd::path::to_abspath

    if [[ $? -eq 1 ]]; then
        return $_ENHANCD_FAILURE
    fi
}

__enhancd::arguments::none()
{
    if [[ "$ENHANCD_DISABLE_HOME" == 1 ]]; then
        echo "$HOME"
        return 0
    fi

    __enhancd::list | __enhancd::filter
}

__enhancd::arguments::given()
{
    if [[ -d $1 ]]; then
        echo "$1"
        return 0
    fi

    __enhancd::list "$1" | __enhancd::filter
}
