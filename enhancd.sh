# enhancd - A enhanced cd shell function wrapper

# Version:    v2.1.1
# Repository: https://github.com/b4b4r07/enhancd
# Author:     b4b4r07 (BABAROT)
# License:    MIT
# Note:
#   this enhancd.sh supports bash and zsh only
#

ENHANCD_DIR=~/.enhancd
ENHANCD_LOG=$ENHANCD_DIR/enhancd.log
export ENHANCD_DIR
export ENHANCD_LOG

# die puts a string to stderr
die() {
    echo "$1" 1>&2
}

# unique uniques a stdin contents
unique() {
    awk '!a[$0]++' "${1:--}"
}

# reverse reverses a stdin contents
reverse() {
    perl -e 'print reverse <>'
}

# available narrows list down to one
available() {
    local c i list

    list="$1"

    # Replace a colon with a newline
    c="$(echo "$list" | tr ":" "\n")"

    # Loop until has function returns true
    for i in ${c[@]}
    do
        if has "$i"; then
            echo "$i"
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

# cd::list returns a directory list for changing directory of enhancd
cd::list()
{
    # if no argument is given, read stdin
    if [ -p /dev/stdin ]; then
        cat -
    else
        cat "$ENHANCD_LOG"
    fi | reverse | unique
    #    ^- needs to be inverted before unique
}

# cd::narrow returns result narrowed down by $1
cd::narrow()
{
    awk '/\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null
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
    local file i

    file=$(
    for ((i=1; i<${#PWD}+1; i++))
    do
        if [[ ${PWD:0:$i+1} =~ /$ ]]; then
            echo ${PWD:0:$i}
        fi
    done
    find $PWD -maxdepth 1 -type d | grep -v "\/\."
    )

    echo "${file[@]}"
}

# cd::makelog carefully open/close the log
cd::makelog()
{
    if [ ! -d "$ENHANCD_DIR" ]; then
        mkdir -p "$ENHANCD_DIR"
    fi

    local esc

    # Create ~/.enhancd/enhancd.log
    touch "$ENHANCD_LOG"

    # Prepare a temporary file for overwriting
    esc="$ENHANCD_DIR"/enhancd."$(date +%d%m%y)"$$$RANDOM

    # $1 should be a function name
    # Run $1 process, and puts to the temporary file
    $1 >"$esc"

    # Create a backup in preparation for the failure of the overwriting
    cp -f "$ENHANCD_LOG" $ENHANCD_DIR/enhancd.backup
    rm "$ENHANCD_LOG"

    # Run the overwrite process
    mv "$esc" "$ENHANCD_LOG" 2>/dev/null

    # Restore from the backup if overwriting fails
    if [ $? -eq 0 ]; then
        rm "$ENHANCD_DIR"/enhancd.backup
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
    cat "$ENHANCD_LOG"
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
    # If you pass a dot (.) as an argument to cd::interface
    if [ "$1" = "." ]; then
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

    case "$wc" in
        0 )
            # Unbelievable branch
            die "$LINENO: something is wrong"
            return 1
            ;;
        1 )
            # If you pass a dot (.) as an argument to cd::interface
            if [ "$flag_dot" = "enable" ]; then
                builtin cd "$(echo $PWD | grep -o "^.*/$list")"
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
                # If you pass a dot (.) as an argument to cd::interface
                if [ "$flag_dot" = "enable" ]; then
                    builtin cd "$(echo $PWD | grep -o "^.*/$t")"
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
#         -	latest 10 histories that do not include the current directory
#         .	behave like zsh-bd
#
#     Exit Status:
#     Returns 0 if the directory is changed; non-zero otherwise
#
cd() {
    # t is an argument of the list for cd::interface
    local t

    cd::makelog "cd::refresh"

    # Supports stdin
    # echo $HOME | cd
    if [ -p /dev/stdin ]; then
        local stdin
        stdin="$(cat -)"

        if [ -d "$stdin" ]; then
            builtin cd "$stdin"
        else
            die "$stdin: no such file or directory"
            return 1
        fi
    else
        # If a hyphen is passed as the argument,
        # searchs from the last 10 directory items in the log
        if [ "$1" = "-" ]; then
            t="$(cd::list | grep -v "^$PWD$" | head | cd::narrow "$2")"
            cd::interface "${t:-$2}"
            return $?
        fi

        # If a dot is passed as the argument,
        # it behaves like a zsh-bd plugin
        # In short, you can jump back to a specific directory,
        # without doing `cd ../../..`
        if [ "$1" = "." ]; then
            local i
            t="$(for i in $(echo $PWD | tr "/" " "); do echo "$i"; done | grep "$2")"
            cd::interface "." "${t:-$2}"
            return $?
        fi

        # Process a regular argument
        # If a given argument is a directory,
        # call builtin cd function; cd::interface otherwise
        if [ -d "$1" ]; then
            builtin cd "$1"
        else
            # If no argument is given, imitate builtin cd command and rearrange
            # the history so that the HOME environment variable could be latest
            if empty "$1"; then
                t="$({ cat "$ENHANCD_LOG"; echo "$HOME"; } | cd::list)"
            else
                t="$(cd::list | cd::narrow "$1")"
            fi
            # If the t is empty, pass $1 to cd::interface instead of the t
            cd::interface "${t:-$1}"
        fi
    fi

    cd::makelog "cd::assemble"
}

# For zsh
if [ -n "$ZSH_VERSION" ]; then
    add-zsh-hook chpwd cd::add
fi

# For bash
if [ -n "$BASH_VERSION" ]; then
    PROMPT_COMMAND="cd::add; $PROMPT_COMMAND"
fi
