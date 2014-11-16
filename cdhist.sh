# Only shell script for bash and zsh
if [ ! "$BASH_VERSION" -a ! "$ZSH_VERSION" ]; then
    echo "Require bash or zsh"
    exit
fi

###  cdhist.sh
###
###  Copyright (c) 2001 Yusuke Shinyama <yusuke at cs . nyu . edu>
###
###  Permission to use, copy, modify, distribute this software and
###  its documentation for any purpose is hereby granted, provided
###  that existing copyright notices are retained in all copies and
###  that this notice is included verbatim in any distributions. 
###  This software is provided ``AS IS'' without any express or implied
###  warranty.
###

###  WARNING: THIS SCRIPT IS FOR GNU BASH ONLY!

###  What is this?
###
###  Cdhist adds 'web-browser like history' to your bash shell.
###  Every time you change the current directory it records the directory
###  you can go back by simply typing a short command such as '-' or '+',
###  just like clicking web-browsers's 'back' button.
###  It's more convenient than using directory stacks when
###  you walk around two or three directories.
###

###  Usage
###
###  Just call this file from your .bashrc script.
###  The following commands are added.
###
###  cd [pathname]
###	Go to the given directory, or your home directory if 
###	pathname is omitted. This overrides the original command.
###	You can use it by typing '\cd'.
###
###  + [n]
###	'Forward' button. Go to the n'th posterior directory in the history.
###	Go to the next directory if the number is omitted.
###
###  - [n]
###	'Back' button. Go to the n'th prior directory in the history.
###	Go to the previous directory if the number is omitted.
###
###  = [n]
###	Show histories with directory numbers.
###
###	A directory number shows the index to the current directory 
###	in the history. The current directory always has directory number 0.
###	For prior directories, a negative number is given.
###	For posterior directories, a positive number is given.
###
###  cdhist_reset
###	Clear the cd history.
###

###  Example
###
###	/home/yusuke:$ . cdhist.sh
###	/home/yusuke:$ cd /tmp
###	/tmp:$ cd /usr/bin
###	/usr/bin:$ cd /etc
###	/etc:$ -
###	/usr/bin:$ -
###	/tmp:$ +
###	/usr/bin:$ =
###	-2 ~
###	-1 /tmp
###	 0:/usr/bin
###	 1 /etc
###	/usr/bin:$ - 2
###     /home/yusuke:$
###


declare CDHIST_CDLOG
CDHIST_CDQMAX=10
declare -a CDHIST_CDQ
CDHIST_CDLOG="$HOME/zsh_cdhist"

function cdhist_reset()
{
    CDHIST_CDQ=("$PWD")
}

function cdhist_disp()
{
    echo "$*" | sed "s $HOME ~ g"
}

function cdhist_add()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    CDHIST_CDQ=("$1" "${CDHIST_CDQ[@]}")
}

function cdhist_del()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i=${1-0}
    if [ ${#CDHIST_CDQ[@]} -le 1 ]; then return; fi
    for ((; i<${#CDHIST_CDQ[@]}-1; i++)); do
        CDHIST_CDQ[$i]="${CDHIST_CDQ[$((i+1))]}"
    done
    if [ "$ZSH_NAME" = "zsh" ]; then
        CDHIST_CDQ=(${CDHIST_CDQ[0, (($i-1))]})
    else
        unset CDHIST_CDQ[$i]
    fi
}

function cdhist_rot()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i
    local -a q
    for ((i=0; i<$1; i++)); do
        q[$i]="${CDHIST_CDQ[$(((i+$1+$2)%$1))]}"
    done
    for ((i=0; i<$1; i++)); do
        CDHIST_CDQ[$i]="${q[$i]}"
    done
}

function cdhist_cd()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i f=0
    builtin cd "$@" || return 1
    for ((i=0; i<${#CDHIST_CDQ[@]}; i++)); do
        if [ "${CDHIST_CDQ[$i]}" = "$PWD" ]; then f=1; break; fi
    done
    if [ $f -eq 1 ]; then
        cdhist_rot $((i+1)) -1
    elif [ ${#CDHIST_CDQ[@]} -lt $CDHIST_CDQMAX ]; then 
        cdhist_add "$PWD"
    else
        cdhist_rot ${#CDHIST_CDQ[@]} -1
        CDHIST_CDQ[0]="$PWD"
    fi
}

function cdhist_history()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i d
    if [ $# -eq 0 ]; then
        for ((i=${#CDHIST_CDQ[@]}-1; 0<=i; i--)); do
            cdhist_disp " $i ${CDHIST_CDQ[$i]}"
        done
    elif [ "$1" -lt ${#CDHIST_CDQ[@]} ]; then
        d=${CDHIST_CDQ[$1]}
        if builtin cd "$d" 2>/dev/null; then
            cdhist_rot $(($1+1)) -1
        else
            echo "Unfortunately, ${CDHIST_CDQ[$1]} is not available" >/dev/stderr
            cdhist_refresh "${CDHIST_CDQ[$1]}"
            cdhist_del $1
            return 1
        fi
        cdhist_disp "${CDHIST_CDQ[@]}"
    fi
}

function cdhist_refresh()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi

    local -a delete_candidate
    local i

    if [ -z "$1" ]; then
        for i in "$(cdhist_logview)"
        do
            [ ! -d "$i" ] && delete_candidate+=($i)
        done
    else
        delete_candidate+=("$@")
    fi

    local raw_date
    raw_date=$(cat $CDHIST_CDLOG)

    for i in "${delete_candidate[@]}"
    do
      raw_date=$(echo "${raw_date}" | \grep -E -x -v "$i")
    done
    echo "${raw_date}" >|$CDHIST_CDLOG
}

function cdhist_forward()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    cdhist_rot ${#CDHIST_CDQ[@]} -${1-1}
    if ! builtin cd "${CDHIST_CDQ[0]}"; then
        cdhist_del 0
    fi
    cdhist_disp "${CDHIST_CDQ[@]}"
}

function cdhist_back()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    cdhist_rot ${#CDHIST_CDQ[@]} ${1-1}
    if ! builtin cd "${CDHIST_CDQ[0]}"; then
        cdhist_del 0
    fi
    cdhist_disp "${CDHIST_CDQ[@]}"
}

function cdhist_logview() { tac <(tac $CDHIST_CDLOG | awk '!colname[$0]++{print $0}'); }
function cdhist_initialize()
{
    local count
    local -a log_array

    count=0
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    log_array=( $(cdhist_logview) )
    for ((i=${#log_array[*]}-1; i>=0; i--))
    do
        CDHIST_CDQ[$count]="${log_array[i]}"
        let count++
        [ $count -eq $CDHIST_CDQMAX ] && break
    done
}

#if [ ${#CDHIST_CDQ[@]} = 0 ]; then cdhist_reset; fi
if [ -f $CDHIST_CDLOG ]; then
    cdhist_initialize
    unset -f cdhist_initialize
    cdhist_cd $HOME
else
    cdhist_reset
fi


###  Aliases
###

function cd { cdhist_cd "$@"; }
function + { cdhist_forward "$@"; }
function - { cdhist_back "$@"; }
function = { cdhist_history "$@"; }
