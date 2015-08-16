# enhancd - A enhanced cd shell function wrapper

# Version:    v2.1.4
# Repository: https://github.com/b4b4r07/enhancd
# Author:     b4b4r07 (BABAROT)
# License:    MIT
# Note:
#   this enhancd.sh supports bash and zsh only
#

ENHANCD_DIR=~/.enhancd
ENHANCD_LOG="$ENHANCD_DIR"/enhancd.log
export ENHANCD_DIR
export ENHANCD_LOG

# die puts a string to stderr
die() {
    echo "$1" 1>&2
}

# unique uniques a stdin contents
unique() {
    if empty "$1"; then
        cat <&0
    else
        cat "$1"
    fi | awk '!a[$0]++' 2>/dev/null
}

# reverse reverses a stdin contents
reverse() {
    if empty "$1"; then
        cat <&0
    else
        cat "$1"
    fi | awk '
    {
        line[NR] = $0
    }
    END {
        for (i = NR; i > 0; i--) {
            print line[i]
        }
    }' 2>/dev/null
}

# available narrows list down to one
available() {
    local x candidates

    # candidates should be list like "a:b:c" concatenated by a colon
    candidates="$1:"

    while [ -n "$candidates" ]; do
        # the first remaining entry
        x=${candidates%%:*}
        # reset candidates
        candidates=${candidates#*:}

        # check if x is available
        if has "$x"; then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}

# empty returns true if $1 is empty value
empty() {
    [ -z "$1" ]
}

# has returns true if $1 exists in the PATH environment variable
has() {
    if empty "$1"; then
        return 1
    fi

    type "$1" >/dev/null 2>/dev/null
    return $?
}

# nl reads lines from the named file or the standard input if the file argument is ommitted,
# applies a configurable line numbering filter operation and writes the result to the standard output
nl() {
    # d in awk's argument is a delimiter
    awk -v d="${1:-": "}" '
    BEGIN {
        i = 1
    }
    {
        print i d $0
        i++
    }' 2>/dev/null
}

# cd::get_dirstep returns a list of stepwise path
cd::get_dirstep() {
    # cd::get_dirstep requires $1 that should be a path
    if empty "$1"; then
        die "too few arguments"
        return 1
    fi

    local slash c cwd
    slash="$(echo "$1" | sed -e 's@[^/]@@g')"
    # c is a length of all slash(s) in $1
    c="${#slash}"

    # Print a stepwise path
    while [ "$c" -ge 0 ]
    do
        echo "${cwd:=$1}"
        # refresh cwd
        cwd="$(dirname "$cwd")"
        # count down slash
        c="$(expr "$c" - 1)"
    done
}

# cd::cat_log outputs the content of the log file or empty line to stdin
cd::cat_log()
{
    if [ -s "$ENHANCD_LOG" ]; then
        cat "$ENHANCD_LOG"
    else
        echo
    fi
}

# cd::split_path decomposes the path with a slash as a delimiter
cd::split_path()
{
    local arg

    awk -v arg="${1:-$PWD}" '
    # has_prefix tests whether the string s begins with pre.
    function has_prefix(s, pre,        pre_len, s_len) {
        pre_len = length(pre)
        s_len   = length(s)

        return pre_len <= s_len && substr(s, 1, pre_len) == pre
    }

    # isabs returns true if the path is absolute.
    function isabs(pathname) {
        return length(pathname) > 0 && has_prefix(pathname, "/")
    }

    BEGIN {
        # check if arg is an valid path
        if (!isabs(arg)) {
            print "split_path requires an absolute path begins with a slash" >"/dev/stderr"
            exit 1
        }

        # except for the beginning of the slash
        s = substr(arg, 2)
        num = split(s, arr, "/")

        # display the beginning of the path
        print substr(arg, 1, 1)

        # decompose the path by a slash
        for (i = 1; i < num; i++) {
            print arr[i]
        }
    }'
}

# cd::get_dirname returns the divided directory name with a slash
cd::get_dirname()
{
    local is_uniq dir

    # dir is a target directory that defaults to the PWD
    dir="${1:-$PWD}"

    # uniq is the variable that checks whether there is
    # the duplicate directory in the PWD environment variable
    is_uniq="$(cd::split_path "$dir" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}')"

    # Tests whether is_uniq is true or false
    if [ "$is_uniq" -eq 1 ]; then
        # is_uniq is true
        cd::split_path "$dir"
    else
        # is_uniq is false
        cd::split_path "$dir" | awk '{ printf("%d: %s\n", NR, $1); }'
    fi
}

# cd::get_abspath regains the path from the divided directory name with a slash
cd::get_abspath()
{
    # cd::get_abspath requires two arguments
    if [ $# -lt 2 ]; then
        die "too few arguments"
        return 1
    fi

    # $1 is cwd, $2 is dir
    local cwd dir
    cwd="$(dirname "$1")"

    local num c

    # It searches the directory name from the rear of the PWD,
    # and returns the path to where it was found
    if echo "$2" | grep -q "[0-9]:"; then
        # When decomposing the PWD with a slash,
        # put the number to it if there is the same directory name.

        # num is a number for identification
        num="$(echo "$2" | cut -d: -f1)"

        local i
        if [ -n "$num" ]; then
            # c is a line number
            c=2

            # It is listed path stepwise
            cd::get_dirstep "$1" | reverse | nl ":" | grep "^$num" | cut -d: -f2
        fi
    else
        # If there are no duplicate directory name
        awk -v cwd="$cwd" -v dir="$2" '
        # erase erases the part of the path
        function erase(str, pos) {
            return substr(str, 1, pos-1)
        }

        # rindex returns the index of the last instance of find in string,
        # or 0 if find is not present
        function rindex(string, find, k, ns, nf) {
            ns = length(string)
            nf = length(find)
            for (k = ns+1-nf; k >= 1; k--) {
                if (substr(string, k, nf) == find) {
                    return k
                }
            }
            return 0
        }

        BEGIN {
            # If dir is a slash, return a slash and exit
            if (dir == "/") {
                print "/"
                exit
            }

            # pos is a position of dir in cwd
            pos = rindex(cwd, dir)

            # If it is not find the dir in the cwd, then exit
            if (pos == 0) {
                print cwd
                exit
            }

            # convert the divided directory name to the absolute path
            # that the directory name is contained
            print erase(cwd, pos+length(dir))
        }' 2>/dev/null
    fi
}

# cd::list returns a directory list for changing directory of enhancd
cd::list()
{
    # if no argument is given, read stdin
    if [ -p /dev/stdin ]; then
        cat <&0
    else
        cd::cat_log
    fi | reverse | unique
    #    ^- needs to be inverted before unique
}

# cd::fuzzy returns a list of hits in the fuzzy search
cd::fuzzy()
{
    if empty "$1"; then
        die "too few arguments"
        return 1
    fi

    awk -v search_string="$1" '
    BEGIN {
        FS = "/";
    }

    {
        # calculates the degree of similarity
        if ( (1 - leven_dist($NF, search_string) / (length($NF) + length(search_string))) * 100 >= 70 ) {
            # When the degree of similarity of search_string is greater than or equal to 70%,
            # to display the candidate path
            print $0
        }
    }

    # leven_dist returns the Levenshtein distance two text string
    function leven_dist(a, b) {
        lena = length(a);
        lenb = length(b);

        if (lena == 0) {
            return lenb;
        }
        if (lenb == 0) {
            return lena;
        }

        for (row = 1; row <= lena; row++) {
            m[row,0] = row
        }
        for (col = 1; col <= lenb; col++) {
            m[0,col] = col
        }

        for (row = 1; row <= lena; row++) {
            ai = substr(a, row, 1)
            for (col = 1; col <= lenb; col++) {
                bi = substr(b, col, 1)
                if (ai == bi) {
                    cost = 0
                } else {
                    cost = 1
                }
                m[row,col] = min(m[row-1,col]+1, m[row,col-1]+1, m[row-1,col-1]+cost)
            }
        }

        return m[lena,lenb]
    }

    # min returns the smaller of x, y or z
    function min(a, b, c) {
        result = a

        if (b < result) {
            result = b
        }

        if (c < result) {
            result = c
        }

        return result
    }' 2>/dev/null
}

# cd::narrow returns result narrowed down by $1
cd::narrow()
{
    local stdin m

    # Save stdin
    stdin="$(cat <&0)"
    m="$(echo "$stdin" | awk '/\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null)"

    # If m is empty, do fuzzy-search; otherwise puts m
    if empty "$m"; then
        echo "$stdin" | cd::fuzzy "$1"
    else
        echo "$m"
    fi
}

# cd::enumrate returns a list that was decomposed with a slash 
# to the directory path that visited just before
# e.g., /home/lisa/src/github.com
# -> /home
# -> /home/lisa
# -> /home/lisa/src
# -> /home/lisa/src/github.com
cd::enumrate()
{
    cd::get_dirstep "$PWD" | reverse
    find "$PWD" -maxdepth 1 -type d | grep -v "\/\."
}

# cd::makelog carefully open/close the log
cd::makelog()
{
    if [ ! -d "$ENHANCD_DIR" ]; then
        mkdir -p "$ENHANCD_DIR"
    fi

    # an temporary variable
    local esc

    # Create ~/.enhancd/enhancd.log
    touch "$ENHANCD_LOG"

    # Prepare a temporary file for overwriting
    esc="$ENHANCD_DIR"/enhancd."$(date +%d%m%y%H%M%S)"$$$RANDOM

    # $1 should be a function name
    # Run $1 process, and puts to the temporary file
    if empty "$1"; then
        cd::list | reverse >"$esc"
    else
        $1 >"$esc"
    fi

    # Create a backup in preparation for the failure of the overwriting
    cp -f "$ENHANCD_LOG" $ENHANCD_DIR/enhancd.backup
    rm -f "$ENHANCD_LOG"

    # Run the overwrite process
    mv "$esc" "$ENHANCD_LOG" 2>/dev/null

    # Restore from the backup if overwriting fails
    if [ $? -eq 0 ]; then
        rm -f "$ENHANCD_DIR"/enhancd.backup
    else
        cp -f "$ENHANCD_DIR"/enhancd.backup "$ENHANCD_LOG"
    fi
}

# cd::refresh returns the result of removing a directory that does not exist from the log
cd::refresh()
{
    local line

    # Remove all to a directory that does not exist
    while read line
    do
        [ -d "$line" ] && echo "$line"
    done <"$ENHANCD_LOG"
}

# cd::assemble returns the assembled log
cd::assemble()
{
    cd::enumrate
    cd::cat_log
    pwd
}

# cd::add adds a current working directory path to the log
cd::add()
{
    # No overlaps and no underlaps in the log
    if [ ! -f "$ENHANCD_LOG" -o "$(tail -n 1 "$ENHANCD_LOG")" = "$PWD" ]; then
        return 0
    fi

    pwd >>"$ENHANCD_LOG"
}

# cd::interface searches the directory that in the given list, 
# and extracts with the filter if the list has several paths, 
# otherwise, call cd::builtin function
cd::interface()
{
    # Sets default values to ENHANCD_FILTER if it is empty
    if empty "$ENHANCD_FILTER"; then
        ENHANCD_FILTER="fzf:peco:percol:gof:pick:icepick:sentaku:selecta"
        export ENHANCD_FILTER
    fi

    # Narrows the ENHANCD_FILTER environment variables down to one
    # and sets it to the variables filter
    local filter
    filter="$(available "$ENHANCD_FILTER")"
    if empty "$ENHANCD_FILTER"; then
        die '$ENHANCD_FILTER not set'
        return 1
    elif empty "$filter"; then
        die "$ENHANCD_FILTER is invalid \$ENHANCD_FILTER"
        return 1
    fi

    # Check if options are specified
    # If you pass a double-dot (..) as an argument to cd::interface
    if [ "$1" = ".." ]; then
        shift
        local flag_dot
        flag_dot="enable"
    fi

    # The list should be a directory list separated by a newline (\n).
    # e.g.,
    #   /home/lisa/src
    #   /home/lisa/work/temp
    local list
    list="$1"

    # If no argument is given to cd::interface
    if empty "$list"; then
        die "cd::interface requires an argument at least"
        return 1
    fi

    # Count lines in the list
    local wc
    wc="$(echo "$list" | grep -c "")"

    # main conditional branch
    case "$wc" in
        0 )
            # Unbelievable branch
            die "$LINENO: something is wrong"
            return 1
            ;;
        1 )
            # If you pass a double-dot (..) as an argument to cd::interface
            if [ "$flag_dot" = "enable" ]; then
                builtin cd "$(cd::get_abspath "$PWD" "$list")"
                return $?
            fi

            # A regular behavior
            if [ -d "$list" ]; then
                builtin cd "$list"
            else
                die "$list: no such file or directory"
                return 1
            fi
            ;;
        * )
            local t
            t="$(echo "$list" | eval "$filter")"
            if ! empty "$t"; then
                # If you pass a double-dot (..) as an argument to cd::interface
                if [ "$flag_dot" = "enable" ]; then
                    builtin cd "$(cd::get_abspath "$PWD" "$t")"
                    return $?
                fi

                # A regular behavior
                if [ -d "$t" ]; then
                    builtin cd "$t"
                else
                    die "$t: no such file or directory"
                    return 1
                fi
            fi
            ;;
    esac
}

# cd is redefined shell builtin cd function and is overrided
#
# SYNOPSIS
#     cd [-] [DIR]
#
# DESCRIPTION
#     Change the current directory to DIR. The default DIR is all directories that
#     you visited in the past in the value of the ENHANCD_LOG shell variable
#
#     The variable ENHANCD_FILTER defines a visual filter command you want to use
#     The visual filter such as peco and fzf in ENHANCD_FILTER are separated by a colon (:)
#
#     Options:
#         -     latest 10 histories that do not include the current directory
#         ..    like zsh-bd
#
#     Exit Status:
#     Returns 0 if the directory is changed; non-zero otherwise
#
cd::cd()
{
    # In zsh it will cause field splitting to be performed
    # on unquoted parameter expansions.
    if has "setopt" && ! empty "$ZSH_VERSION"; then
        # Note in particular the fact that words of unquoted parameters are not
        # automatically split on whitespace unless the option SH_WORD_SPLIT is set;
        # see references to this option below for more details.
        # This is an important difference from other shells.
        # (Zsh Manual 14.3 Parameter Expansion)
        setopt localoptions SH_WORD_SPLIT
    fi

    # t is an argument of the list for cd::interface
    local t

    # First of all, this cd::makelog and cd::refresh function creates it
    # if the enhancd history file does not exist
    cd::makelog
    # Then, remove non existing directories from the history and refresh it
    cd::makelog "cd::refresh"

    # If a hyphen is passed as the argument,
    # searchs from the last 10 directory items in the log
    if [ "$1" = "-" ]; then
        t="$(cd::list | grep -v "^$PWD$" | head | cd::narrow "$2")"
        cd::interface "${t:-$2}"
        return $?
    fi

    # If a double-dot is passed as the argument,
    # it behaves like a zsh-bd plugin
    # In short, you can jump back to a specific directory,
    # without doing `cd ../../..`
    if [ "$1" = ".." ]; then
        t="$(cd::get_dirname "$PWD" | reverse | grep "$2")"
        cd::interface ".." "${t:-$2}"
        return $?
    fi

    # Process a regular argument
    # If a given argument is a directory that exists already,
    # call builtin cd function; cd::interface otherwise
    if [ -d "$1" ]; then
        builtin cd "$1"
    else
        # If no argument is given, imitate builtin cd command and rearrange
        # the history so that the HOME environment variable could be latest
        if empty "$1"; then
            t="$({ cd::cat_log; echo "$HOME"; } | cd::list)"
        else
            t="$(cd::list | cd::narrow "$1")"
        fi

        # If the t is empty, pass $1 to cd::interface instead of the t
        cd::interface "${t:-$1}"
    fi

    # Finally, assemble the cd history
    cd::makelog "cd::assemble"

    # Add $PWD to the enhancd log
    cd::add
}

eval "alias ${ENHANCD_COMMAND:="cd"}=cd::cd"
export ENHANCD_COMMAND
if [ "$ENHANCD_COMMAND" != "cd" ]; then
    unalias cd 2>/dev/null
fi

