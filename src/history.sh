__enhancd::history::origin()
{
    local is_home=false

    # Shift arguments in advance if given
    # because it's on subshell beyond a pipe
    if [[ $1 == '--home' ]]; then
        is_home=true
        shift
    fi

    if [[ -f $ENHANCD_DIR/enhancd.log ]]; then
        cat "$ENHANCD_DIR/enhancd.log"
        $is_home && echo "$HOME"
    fi
}

__enhancd::history::list()
{
    __enhancd::history::origin \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::exists \
        | __enhancd::filter::fuzzy "$@" \
        | __enhancd::command::grep -vx "$PWD" || true
}

__enhancd::history::update()
{
    {
        __enhancd::filepath::list_step | __enhancd::filter::reverse
        __enhancd::filepath::walk
        __enhancd::history::origin --home
    } \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::reverse
    __enhancd::filepath::current_dir
}
