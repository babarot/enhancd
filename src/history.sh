__enhancd::history::open()
{
    if [[ -f $ENHANCD_DIR/enhancd.log ]]; then
        command cat "$ENHANCD_DIR/enhancd.log"
        return $?
    fi
    return 1
}

__enhancd::history::list()
{
    __enhancd::history::open \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::exists \
        | __enhancd::filter::fuzzy "$@" \
        | __enhancd::filter::exclude "$PWD"
}

__enhancd::history::update()
{
    {
        __enhancd::filepath::list_step | __enhancd::filter::reverse
        __enhancd::filepath::walk
        __enhancd::history::open
        echo "$HOME"
    } \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::reverse
    __enhancd::filepath::current_dir
}
