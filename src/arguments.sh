__enhancd::arguments::option()
{
    local opt="$1" action
    shift

    __enhancd::utils::die \
        "$opt: no such option\n"
    return 1

    #action="$(
    #"$ENHANCD_ROOT/.bin/json.sh" \
    #    "$ENHANCD_ROOT/custom.json" \
    #    | awk -v opt="$opt" '
    #        $2 == opt{
    #            sub(/\.(short|long$)/, "", $1)
    #            act = $1 ".action";
    #        }
    #        $1 == act{
    #            $1 = "";
    #            print $0;
    #        }'
    #)"

    #if [[ -z $action ]]; then
    #    __enhancd::utils::die \
    #        "$opt: no such option\n"
    #    return 1
    #fi

    #eval "$action $@"
}

__enhancd::arguments::hyphen()
{
    if [[ $ENHANCD_DISABLE_HYPHEN == 1 ]]; then
        echo "$OLDPWD"
        return 0
    fi

    __enhancd::log::list "$1" | head | __enhancd::log::filter
}

__enhancd::arguments::dot()
{
    if [[ $ENHANCD_DISABLE_DOT == 1 ]]; then
        echo ".."
        return 0
    fi

    __enhancd::path::go_upstairs "$PWD" \
        | __enhancd::utils::reverse \
        | __enhancd::utils::grep "$1" \
        | __enhancd::log::filter \
        | __enhancd::path::to_abspath

    # Returns false if __enhancd::path::to_abspath fails
    # __enhancd::path::to_abspath returns false
    # if __enhancd::log::filter doesn't output anything
    if [[ $? -eq 1 ]]; then
        if [[ -n $1 ]]; then
            # Returns false if an argument is given
            return $_ENHANCD_FAILURE
        else
            # Returns true when detecting to press Ctrl-C in selection
            return $_ENHANCD_SUCCESS
        fi
    fi
}

__enhancd::arguments::none()
{
    if [[ "$ENHANCD_DISABLE_HOME" == 1 ]]; then
        echo "$HOME"
        return 0
    fi

    __enhancd::log::list --home | __enhancd::log::filter
}

__enhancd::arguments::given()
{
    if [[ -d $1 ]]; then
        echo "$1"
        return 0
    fi

    __enhancd::log::list "$1" | __enhancd::log::filter
}
