__enhancd::history::show()
{
    if [[ -f $ENHANCD_DIR/enhancd.log ]]; then
        cat "$ENHANCD_DIR/enhancd.log"
        return $?
    fi
    return 1
}

__enhancd::history::list()
{
    __enhancd::history::show \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::exists \
        | __enhancd::filter::fuzzy "$@" \
        | __enhancd::filter::by_not_cwd
}

__enhancd::history::update()
{
    {
        __enhancd::filepath::list_step | __enhancd::filter::reverse
        __enhancd::filepath::walk
        __enhancd::history::show
        echo "$HOME"
    } \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::reverse
    __enhancd::filepath::current_dir
}
