# __enhancd::path::to_abspath regains the path from the divided directory name with a slash
__enhancd::path::to_abspath()
{
    local cwd dir num
    cwd="${PWD%/*}"
    dir="$(cat <&0)"
    if [[ -z $dir ]]; then
        return 1
    fi

    # It searches the directory name from the rear of the PWD,
    # and returns the path to where it was found
    if echo "$dir" | __enhancd::utils::grep -q "[0-9]: "; then
        # When decomposing the PWD with a slash,
        # put the number to it if there is the same directory name.

        # num is a number for identification
        num="$(echo "$dir" | cut -d: -f1)"

        if [ -n "$num" ]; then
            # It is listed path stepwise
            __enhancd::path::step_by_step "$1" \
                | __enhancd::filter::reverse \
                | __enhancd::utils::nl ":" \
                | __enhancd::utils::grep "^$num" \
                | cut -d: -f2
        fi
    else
        # If there are no duplicate directory name
        $ENHANCD_AWK \
            -f "$ENHANCD_ROOT/src/share/to_abspath.awk" \
            -v cwd="$cwd" \
            -v dir="$dir"
    fi
}

# __enhancd::path::split decomposes the path with a slash as a delimiter
__enhancd::path::split()
{
    $ENHANCD_AWK \
        -f "$ENHANCD_ROOT/src/share/split.awk" \
        -v arg="${1:-$PWD}" #-v show_fullpath="$ENHANCD_DOT_SHOW_FULLPATH"
}

# __enhancd::path::step_by_step returns a list of stepwise path
__enhancd::path::step_by_step()
{
    $ENHANCD_AWK \
        -f "$ENHANCD_ROOT/src/share/step_by_step.awk" \
        -v dir="${1:-$PWD}"
}

__enhancd::path::go_upstairs()
{
    local dir

    # dir is a target directory that defaults to the PWD
    dir="${1:-$PWD}"

    if [[ $ENHANCD_DOT_SHOW_FULLPATH == 1 ]]; then
        __enhancd::path::step_by_step \
            | __enhancd::filter::reverse
        return 0
    fi

    # uniq is the variable that checks whether there is
    # the duplicate directory in the PWD environment variable
    if __enhancd::path::split "$dir" | $ENHANCD_AWK -f "$ENHANCD_ROOT/src/share/has_dup_lines.awk"; then
        __enhancd::path::split "$dir" \
            | $ENHANCD_AWK '{ printf("%d: %s\n", NR, $0); }'
    else
        __enhancd::path::split "$dir"
    fi
}

__enhancd::path::scan_cwd()
{
    find "${1:-$PWD}" -maxdepth 1 -type d \
        | __enhancd::utils::grep -v "\/\."
}

__enhancd::path::pwd()
{
    command pwd
}
