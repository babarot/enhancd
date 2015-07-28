# enhancd - A enhanced cd shell function wrapper

# Version:    v2.1.0
# Repository: https://github.com/b4b4r07/enhancd
# Author:     b4b4r07 (BABAROT)
# License:    MIT
# Note:
#   this enhancd.sh supports bash and zsh only
#

basedir=~/.enhancd
logfile=enhancd.log
log=$basedir/$logfile

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
    if [ -z "$1" ]; then
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
        cat $log
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
    if [ ! -d "$basedir" ]; then
        mkdir -p "$basedir"
    fi

    local esc

    # Create ~/.enhancd/enhancd.log
    touch "$log"

    # Prepare a temporary file for overwriting
    esc="$basedir"/enhancd."$(date +%d%m%y)"$$$RANDOM

    # $1 should be a function name
    # Run $1 process, and puts to the temporary file
    $1 >"$esc"

    # Create a backup in preparation for the failure of the overwriting
    cp -f "$log" $basedir/enhancd.backup
    rm "$log"

    # Run the overwrite process
    mv "$esc" "$log" 2>/dev/null

    # Restore from the backup if overwriting fails
    if [ $? -eq 0 ]; then
        rm "$basedir"/enhancd.backup
    else
        cp -f "$basedir"/enhancd.backup "$log"
    fi
}

# cd::refresh returns the result of removing a directory that does not exist from the log
cd::refresh()
{
    while read line
    do
        [ -d "$line" ] && echo "$line"
    done <"$log"
}

# cd::assemble returns the assembled log
cd::assemble()
{
    cd::enumrate
    cat "$log"
    pwd
}

# cd::add adds a current working directory path to the log
cd::add()
{
    # No overlaps and no underlaps in the log
    if [ ! -f "$log" -o "$(tail -n 1 "$log")" = "$PWD" ]; then
        return 0
    fi

    pwd >>"$log"
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

    local list
    list="$1"

    # If no argument is given to cd::interface
    if [ -z "$list" ]; then
        die "cd::interface requires an argument at least"
        return 1
    fi

    # list should be a directory list
    # Count lines in the list
    local wc
    wc="$(echo "$list" | grep -c "")"
    case "$wc" in
        0 )
            die "$LINENO: something is wrong"
            return 1
            ;;
        1 )
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
cd() {
    cd::makelog "cd::refresh"

    # Check if stdin
    if [ -p /dev/stdin ]; then
        builtin cd "$(cat -)"
    else
        # Check a hyphen
        if [ "$1" = "-" ]; then
            local t
            t="$(cd::list | grep -v "^$PWD$" | head | cd::narrow "$2")"
            cd::interface "$t"
            return
        fi

        # A regular action
        if [ -d "$1" ]; then
            builtin cd "$1"
        else
            local t
            if [ -z "$1" ]; then
                t="$({ cat "$log"; echo "$HOME"; } | cd::list)"
            else
                t="$(cd::list | cd::narrow "$1")"
            fi
            # If the t is empty, pass $1 to cd::interface instead of the t
            cd::interface "${t:-$1}"
        fi
    fi

    cd::makelog "cd::assemble"
}

if [ -n "$ZSH_VERSION" ]; then
    add-zsh-hook chpwd cd::add
fi

if [ -n "$BASH_VERSION" ]; then
    PROMPT_COMMAND="cd::add; $PROMPT_COMMAND"
fi

# builtin cd
#
# NAME
#     cd - Change the shell working directory.
# 
# SYNOPSIS
#     cd [-L|-P] [dir]
# 
# DESCRIPTION
#     Change the shell working directory.
#     
#     Change the current directory to DIR.  The default DIR is the value of the
#     HOME shell variable.
#     
#     The variable CDPATH defines the search path for the directory containing
#     DIR.  Alternative directory names in CDPATH are separated by a colon (:).
#     A null directory name is the same as the current directory.  If DIR begins
#     with a slash (/), then CDPATH is not used.
#     
#     If the directory is not found, and the shell option `cdable_vars' is set,
#     the word is assumed to be  a variable name.  If that variable has a value,
#     its value is used for DIR.
#     
#     Options:
#         -L	force symbolic links to be followed
#         -P	use the physical directory structure without following symbolic
#     	links
#     
#     The default is to follow symbolic links, as if `-L' were specified.
#     
#     Exit Status:
#     Returns 0 if the directory is changed; non-zero otherwise.
# 
# SEE ALSO
#     bash(1)
# 
# IMPLEMENTATION
#     GNU bash, version 4.1.5(1)-release (i486-pc-linux-gnu)
#     Copyright (C) 2009 Free Software Foundation, Inc.
#     License GPLv3+: GNU GPL version 3 or later 
