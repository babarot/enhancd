# __enhancd::load
__enhancd::load()
{
    # In zsh it will cause field splitting to be performed
    # on unquoted parameter expansions.
    if __enhancd::utils::has "setopt" && [[ -n $ZSH_VERSION ]]; then
        # Note in particular the fact that words of unquoted parameters are not
        # automatically split on whitespace unless the option SH_WORD_SPLIT is set;
        # see references to this option below for more details.
        # This is an important difference from other shells.
        # (Zsh Manual 14.3 Parameter Expansion)
        setopt localoptions SH_WORD_SPLIT
    fi

    local f line
    enhancd_dirs=()

    while read line
    do
        if [[ -d $line ]]; then
            enhancd_dirs+=("$line")
        fi
    done <"$ENHANCD_LOG"

    # Load all sources
    for f in "$ENHANCD_ROOT"/custom/sources/*.sh
    do
        source "$f"
    done
}

# __enhancd::get_abspath regains the path from the divided directory name with a slash
__enhancd::get_abspath()
{
    if [[ $# -lt 2 ]] || [[ -z $2 ]]; then
        __enhancd::utils::die "too few arguments\n"
        return 1
    fi

    # $1 is cwd, $2 is dir
    local cwd dir num
    cwd="$(dirname "$1")"
    dir="$2"

    # It searches the directory name from the rear of the PWD,
    # and returns the path to where it was found
    if echo "$dir" | command grep -q "[0-9]: "; then
        # When decomposing the PWD with a slash,
        # put the number to it if there is the same directory name.

        # num is a number for identification
        num="$(echo "$dir" | cut -d: -f1)"

        if [ -n "$num" ]; then
            # It is listed path stepwise
            __enhancd::get_dirstep "$1" \
                | __enhancd::utils::reverse \
                | __enhancd::utils::nl ":" \
                | command grep "^$num" \
                | cut -d: -f2
        fi
    else
        # If there are no duplicate directory name
        awk \
            -f "$ENHANCD_ROOT/src/share/get_abspath.awk" \
            -v cwd="$cwd" \
            -v dir="$dir"
    fi
}

# __enhancd::split_path decomposes the path with a slash as a delimiter
__enhancd::split_path()
{
    awk \
        -f "$ENHANCD_ROOT/src/share/split_path.awk" \
        -v arg="${1:-$PWD}"
}

# __enhancd::get_dirstep returns a list of stepwise path
__enhancd::get_dirstep()
{
    awk \
        -f "$ENHANCD_ROOT/src/share/get_dirstep.awk" \
        -v dir="${1:-$PWD}"
}

# __enhancd::get_dirname returns the divided directory name with a slash
__enhancd::get_dirname()
{
    local dir

    # dir is a target directory that defaults to the PWD
    dir="${1:-$PWD}"

    # uniq is the variable that checks whether there is
    # the duplicate directory in the PWD environment variable
    if __enhancd::split_path "$dir" | awk -f "$ENHANCD_ROOT/src/share/has_dup_lines.awk"; then
        __enhancd::split_path "$dir" \
            | awk '{ printf("%d: %s\n", NR, $0); }'
    else
        __enhancd::split_path "$dir"
    fi
}

# __enhancd::list returns a directory list for changing directory of enhancd
__enhancd::list()
{
    local dir arg="$1"

    {
        for dir in "${enhancd_dirs[@]}"
        do
            echo "$dir"
        done
        if [[ $arg == "--home" ]]; then
            shift
            echo "$HOME"
        fi
    } \
        | __enhancd::utils::reverse \
        | __enhancd::utils::unique \
        | command grep -v "^$PWD$" \
        | {
            if [[ $arg == "--narrow" ]]; then
                shift
                __enhancd::narrow "$arg"
            else
                cat -
            fi
          }
}

# __enhancd::narrow returns result narrowed down by $1
__enhancd::narrow()
{
    local stdin m str="$1"

    # Save stdin
    stdin="$(cat <&0)"
    if [[ -z $1 ]]; then
        echo "$stdin"
        return 0
    fi

    m="$(echo "$stdin" | awk 'tolower($0) ~ /\/.?'"$str"'[^\/]*$/{print $0}' 2>/dev/null)"

    # If m is empty, do fuzzy-search; otherwise puts m
    if [[ -z "$m" ]]; then
        echo "$stdin" \
            | awk \
            -f "$ENHANCD_ROOT/src/share/fuzzy.awk" \
            -v search_string="$str"
    else
        echo "$m"
    fi
}

__enhancd::sync()
{
    local dir OLDIFS="$IFS"
    IFS=$'\n'

    enhancd_dirs=( $(
    {
        # Returns a list that was decomposed with a slash
        # to the directory path that visited just before
        # e.g., /home/lisa/src/github.com
        # -> /home
        # -> /home/lisa
        # -> /home/lisa/src
        # -> /home/lisa/src/github.com
        __enhancd::get_dirstep "$PWD" | __enhancd::utils::reverse
        find "$PWD" -maxdepth 1 -type d | command grep -v "\/\."
        for dir in "${enhancd_dirs[@]}"
        do
            echo "$dir"
        done
    } \
        |  __enhancd::utils::reverse \
        | __enhancd::utils::unique \
        | __enhancd::utils::reverse
    ) )
    IFS="$OLDIFS"
    enhancd_dirs+=("$PWD")

    (
        {
            for dir in "${enhancd_dirs[@]}"
            do
                if [[ -d $dir ]]; then
                    echo "$dir"
                fi
            done >|"$ENHANCD_LOG"
        } &
    )
}

__enhancd::options()
{
    local opt="$1" action
    shift

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

__enhancd::filter()
{
    # Narrows the ENHANCD_FILTER environment variables down to one
    # and sets it to the variables filter
    local list="$1"

    # If no argument is given to __enhancd::interface
    if [[ -z $list ]] || [[ -p /dev/stdin ]]; then
        #__enhancd::utils::die "__enhancd::interface requires an argument at least\n"
        list="$(cat <&0)"
    fi

    # Count lines in the list
    local wc
    wc="$(echo "$list" | command grep -c "")"

    # main conditional branch
    case "$wc" in
        1 )
            echo "$list"
            ;;
        * )
            local t
            t="$(echo "$list" | eval "$_ENHANCD_FILTER")"
            if [[ -z $t ]]; then
                return 1
            fi
            echo "$t"
            ;;
    esac
}

__enhancd::cd()
{
    # t is an argument of the list for __enhancd::interface
    local t arg="$1"
    local -i ret=0

    _ENHANCD_FILTER="$(__enhancd::utils::available "$ENHANCD_FILTER")"
    if [[ -z $_ENHANCD_FILTER ]]; then
        __enhancd::utils::die \
            "$ENHANCD_FILTER: Invalid value as ENHANCD_FILTER\n"
        builtin cd "${arg:-$HOME}"
        return $?
    fi

    # Read from standard input
    if [[ -p /dev/stdin ]]; then
        t="$(cat <&0)"
        arg=":stdin:"
    fi

    case "$arg" in
        ":stdin:")
            ;;
        "-")
            # If a hyphen is passed as the argument,
            # searchs from the last 10 directory items in the log
            if [[ "$ENHANCD_DISABLE_HYPHEN" -eq 0 ]]; then
                t="$(__enhancd::list --narrow "$2" | head)"
                t="$(__enhancd::filter "${t:-$2}")"
            else
                t="-"
            fi
            ;;
        "..")
            # If a double-dot is passed as the argument,
            # it behaves like a zsh-bd plugin
            # In short, you can jump back to a specific directory,
            # without doing `cd ../../..`
            if [[ "$ENHANCD_DISABLE_DOT" -eq 0 ]]; then
                t="$(__enhancd::get_dirname "$PWD" | __enhancd::utils::reverse | command grep "$2")"
                t="$(__enhancd::filter "${t:-$2}")"
                t="$(__enhancd::get_abspath "$PWD" "$t" 2>/dev/null)"
            else
                t=".."
            fi
            ;;
        -*|--*)
            shift
            __enhancd::options "$arg" "$@"
            return $?
            ;;
        *)
            if [[ -d $arg ]]; then
                t="$arg"
            else
                if [[ -z $arg ]]; then
                    t="$(__enhancd::list --home)"
                else
                    t="$(__enhancd::list --narrow "$arg")"
                fi
                t="$(__enhancd::filter "${t:-$arg}")"
            fi
            ;;
    esac

    if [[ -z $t ]]; then
        return 0
    fi
    if [[ ! -d $t ]]; then
        __enhancd::utils::die \
            "$t: no such file or directory\n"
        return 1
    fi

    builtin cd "$t"
    ret=$?
    __enhancd::sync

    return $ret
}
