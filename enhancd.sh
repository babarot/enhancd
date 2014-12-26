### enhancd.sh
###

is_zsh()  { test -n "$ZSH_VERSION"; }
is_bash() { test -n "$BASH_VERSION"; }

# Only shell script for bash and zsh
if ! is_bash && ! is_zsh; then
    echo "Require bash or zsh"
    exit 1
fi

# load env variables if exists
if [ -f ~/.enhancd.conf ]; then
    source ~/.enhancd.conf
fi

declare -a ENHANCD_CDQ
declare ENHANCD_AUTOADD=${ENHANCD_AUTOADD:=true}
declare ENHANCD_CDHOME=${ENHANCD_CDHOME:=$HOME}
declare ENHANCD_DATABASE=${ENHANCD_DATABASE:=~/.enhancd.db}
declare ENHANCD_CDQMAX=${ENHANCD_CDQMAX:=10}
declare ENHANCD_COMP_LIMIT=${ENHANCD_COMP_LIMIT:=60}
declare ENHANCD_PECO_BIND=${ENHANCD_PECO_BIND:=^g}
declare ENHANCD_REFRESH_STARTUP=${ENHANCD_REFRESH_STARTUP:=true}
declare ENHANCD_HOME_STARTUP=${ENHANCD_HOME_STARTUP:=true}
declare ENHANCD_DISP_QUEUE=${ENHANCD_DISP_QUEUE:=false}

### General utils {{{1
###

# enhancd_reset {{{2
function enhancd_reset()
{
    ENHANCD_CDQ=("$PWD")
}

# enhancd_disp {{{2
function enhancd_disp()
{
    echo "$*" | sed "s $HOME ~ g"
}

# enhancd_add {{{2
function enhancd_add()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    ENHANCD_CDQ=("$1" "${ENHANCD_CDQ[@]}")
}

# enhancd_del {{{2
function enhancd_del()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i=${1-0}
    if [ ${#ENHANCD_CDQ[@]} -le 1 ]; then return; fi
    for ((; i<${#ENHANCD_CDQ[@]}-1; i++)); do
        ENHANCD_CDQ[$i]="${ENHANCD_CDQ[$((i+1))]}"
    done
    if [ "$ZSH_NAME" = "zsh" ]; then
        ENHANCD_CDQ=(${ENHANCD_CDQ[0, (($i-1))]})
    else
        unset ENHANCD_CDQ[$i]
    fi
}

# enhancd_rot {{{2
function enhancd_rot()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i
    local -a q
    for ((i=0; i<$1; i++)); do
        q[$i]="${ENHANCD_CDQ[$(((i+$1+$2)%$1))]}"
    done
    for ((i=0; i<$1; i++)); do
        ENHANCD_CDQ[$i]="${q[$i]}"
    done
}

# enhancd_cd {{{2
function enhancd_cd()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i f=0
    if ! builtin cd "$@" 2>/dev/null; then
        echo "Unfortunately, $@ is not available" >/dev/stderr
        enhancd_refresh "$@"
        return 1
    fi
    for ((i=0; i<${#ENHANCD_CDQ[@]}; i++)); do
        if [ "${ENHANCD_CDQ[$i]}" = "$PWD" ]; then f=1; break; fi
    done
    if [ $f -eq 1 ]; then
        enhancd_rot $((i+1)) -1
    elif [ ${#ENHANCD_CDQ[@]} -lt $ENHANCD_CDQMAX ]; then
        enhancd_add "$PWD"
    else
        enhancd_rot ${#ENHANCD_CDQ[@]} -1
        ENHANCD_CDQ[0]="$PWD"
    fi
}

# enhancd_history {{{2
function enhancd_history()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    local i d
    if [ $# -eq 0 ]; then
        for ((i=${#ENHANCD_CDQ[@]}-1; 0<=i; i--)); do
            enhancd_disp " $i ${ENHANCD_CDQ[$i]}"
        done
    elif [ "$1" -lt ${#ENHANCD_CDQ[@]} ]; then
        d=${ENHANCD_CDQ[$1]}
        if builtin cd "$d" 2>/dev/null; then
            enhancd_rot $(($1+1)) -1
        else
            echo "Unfortunately, ${ENHANCD_CDQ[$1]} is not available" >/dev/stderr
            enhancd_refresh "${ENHANCD_CDQ[$1]}"
            enhancd_del $1
            return 1
        fi
        if [ ${ENHANCD_DISP_QUEUE:-false} = "true" ]; then
            enhancd_disp "${ENHANCD_CDQ[@]}"
        fi
    fi
}

# enhancd_refresh {{{2
function enhancd_refresh()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi

    IFS=$'\n'
    local -a delete_candidate
    local i

    if [ -z "$1" ]; then
        for i in $(enhancd_logview)
        do
            [ ! -d "$i" ] && delete_candidate+=("$i")
        done
    else
        delete_candidate+=("$@")
    fi

    local raw_date
    raw_date=$(cat $ENHANCD_DATABASE)

    for i in "${delete_candidate[@]}"
    do
        raw_date=$(echo "${raw_date}" | \grep -E -x -v "$i")
    done
    echo "${raw_date}" >|$ENHANCD_DATABASE
}

# enhancd_forward {{{2
function enhancd_forward()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    enhancd_rot ${#ENHANCD_CDQ[@]} -${1-1}
    if ! builtin cd "${ENHANCD_CDQ[0]}"; then
        enhancd_del 0
    fi
    if [ ${ENHANCD_DISP_QUEUE:-false} = "true" ]; then
        enhancd_disp "${ENHANCD_CDQ[@]}"
    fi
}

# enhancd_back {{{2
function enhancd_back()
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    enhancd_rot ${#ENHANCD_CDQ[@]} ${1-1}
    if ! builtin cd "${ENHANCD_CDQ[0]}"; then
        enhancd_del 0
    fi
    if [ ${ENHANCD_DISP_QUEUE:-false} = "true" ]; then
        enhancd_disp "${ENHANCD_CDQ[@]}"
    fi
}

# enhancd_logview {{{2
function enhancd_logview()
{
    if [ "$1" = '-r' ]; then
        enhancd_reverse "$ENHANCD_DATABASE" | awk '!colname[$0]++'
    else
        enhancd_reverse <(enhancd_reverse "$ENHANCD_DATABASE" | awk '!colname[$0]++')
    fi
}

# enhancd_initialize {{{2
function enhancd_initialize()
{
    local count
    local -a log_array

    count=0
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi
    log_array=( $(enhancd_logview) )
    for ((i=${#log_array[*]}-1; i>=0; i--))
    do
        ENHANCD_CDQ[$count]="${log_array[i]}"
        let count++
        [ $count -eq $ENHANCD_CDQMAX ] && break
    done
}

# enhancd_reverse {{{2
function enhancd_reverse() {
$(which ex) -s $1 <<-EOF
g/^/mo0
%p
EOF
}

#if [ ${#ENHANCD_CDQ[@]} = 0 ]; then enhancd_reset; fi

### Special utils {{{1
###

function cd() #{{{2
{
    if [ "$ZSH_NAME" = "zsh" ]; then
        setopt localoptions ksharrays
    fi

    # cd_internal {{{3
    function cd_internal()
    {
        #if [[ "$1" == "--past-only" ]]; then
        #    :
        #else
        #    if [ -d "$1" ]; then
        #        enhancd_cd "$1" && return 0
        #    fi
        #fi
        if [[ "$1" != "--past-only" ]] && [[ -d "$1" ]]; then
            enhancd_cd "$1" && return 0
        else
            # Move to ENHANCD_CDQ, directly
            # known isuue:
            #   unsupport ENHANCD_CDQ because "^[0-9]$"
            #
            [[ "$1" == "--past-only" ]] && shift
            if expr "$1" : '^[0-9]$' >/dev/null; then
                enhancd_cd "${ENHANCD_CDQ[$1]}" && return 0
            fi

            # Move to filered target directory like a ring.
            #
            filered_array=($(enhancd_logview | \grep -i -E "/\.?$1[^/]*$"))
            for ((i=${#filered_array[*]}-1; i>=0; i--))
            do
                # Equals PWD to filered_array[i],
                # go to filered_array of first origin
                # This is means that you can go to other directory.
                #
                if [ "$PWD" = "${filered_array[i]}" ]; then
                    enhancd_cd "${filered_array[0]}" && return 0
                    return 1
                fi
                enhancd_cd "${filered_array[i]}" && return 0
                return 1
            done
        fi
        return 1
    }

    if [ -z "$1" ]; then
        enhancd_cd ${ENHANCD_CDHOME:-$HOME}
        return 0
    fi
    while (( $# > 0 ))
    do
        case "$1" in
            =)
                shift
                if [ "$1" = 'all' ]; then
                    enhancd_logview
                    return 0
                fi
                if [ -z "$1" ] || expr "$1" : '[0-9]*' >/dev/null; then
                    enhancd_history ${1+"$1"} && return 0
                else
                    echo "usage: cd = [num]"
                    return 1
                fi
                ;;
            +)
                shift
                enhancd_forward ${1+"$1"}
                return 0
                ;;
            -)
                shift
                enhancd_back ${1+"$1"}
                return 0
                ;;
            -*)
                if [[ "$1" == '--help' ]]; then
                    echo 'usage: cd [OPTION] path'
                    echo ''
                    echo 'OPTION:'
                    echo '  - <num>          Go back to the <num> previous directory'
                    echo '  + <num>          Forward to the <num> previous directory'
                    echo '  = <num>          Show directory queue and go to <num> directory'
                    echo '  --help           Show this help and exit'
                    echo '  -l,--list        Listup all directory paths'
                    echo '  -L,--list-detail Listup all paths in detail'
                    return 0
                elif [[ "$1" =~ ^-[0-9]$ ]]; then
                    enhancd_history "${1/-/}"
                    return 0
                elif [[ "$1" == '--list' ]] || [[ "$1" == '-l' ]]; then
                    shift
                    if [ -z "$1" ]; then
                        enhancd_logview
                        return 0
                    fi
                    cd_internal --past-only "$1"
                    return 0
                elif [[ "$1" == '--list-detail' ]] || [[ "$1" == '-L' ]]; then
                    shift
                    cd_internal "$1"
                    return 0
                elif [[ "$1" == '--sync' ]] || [[ "$1" == '-s' ]]; then
                    shift
                    enhancd_initialize
                    enhancd_history
                    return 0
                else
                    echo "$1: illegal option"
                    return 1
                fi
                ;;
            *)
                if ! cd_internal "$1" 2>/dev/null; then
                    echo "Unfortunately, \"$1\" was not found in the CWD or the movement history database." >/dev/stderr
                    return 1
                fi
                return 0
                ;;
        esac
    done
    return 1
}
#}}}

# enhancd_autoaddition {{{2
function enhancd_autoaddition()
{
    local i
    local target=$PWD
    local file

    # Do NOT execute if there is registration in the last 10
    # This is in order to avoid duplicate registration
    #
    if enhancd_logview | tail | grep -x -q "$target"; then
        return 0
    fi
    file=$(
    for ((i=1; i<${#target}+1; i++))
    do
        if [[ ${target:0:$i+1} =~ /$ ]]; then
            echo ${target:0:$i}
        fi
    done
    find $target -maxdepth 1 -type d | grep -v "\/\."
    while read LINE
    do
        echo "$LINE"
    done <"$ENHANCD_DATABASE"
    )
    echo "${file[@]}" >|$ENHANCD_DATABASE
}

# enhancd_addhistory {{{2
function enhancd_addhistory()
{
    touch $ENHANCD_DATABASE
    if [ "$PWD" != "$OLDPWD" ]; then
        OLDPWD=$PWD
        if [ ${ENHANCD_AUTOADD:-true} = 'true' ]; then
            enhancd_autoaddition
        fi
        pwd >>$ENHANCD_DATABASE
    fi
}

if is_zsh; then
    function enhancd-peco-cd-complement()
    {
        if ! type peco >/dev/null 2>&1; then
            return 1
        fi
        local selected_dir
        selected_dir=$(enhancd_logview -r | sed "s $HOME ~ g" | peco)

        if [ -n "$selected_dir" ]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N enhancd-peco-cd-complement
    bindkey "${ENHANCD_PECO_BIND:-^g}" enhancd-peco-cd-complement
fi

#function + { enhancd_forward "$@"; }
#function - { enhancd_back "$@"; }
#function = { enhancd_history "$@"; }

### Complement {{{1
###

if is_zsh; then
    setopt listpacked
    LISTMAX=$COLUMNS

    function _cd()
    {
        local context curcontext=$curcontext state line
        declare -A opt_args
        local ret=1

        _arguments -C \
            '--help[Show help and usage]: :->_no_arguments' \
            '(-l --list)'{-l,--list}'[Lists all directories]:list:->list' \
            '(-L --list-detail)'{-L,--list-detail}'[Lists all directories in detail]:detail:->detail' \
            '(-s --sync)'{-s,--sync}'[sync history]: :->_no_arguments' \
            '1: :_no_arguments' \
            '*:: :->args' \
            && ret=0

        IFS=$'\n'

        case $state in
            (list)
                _listup_history && ret=0
                ;;
            (detail)
                _listup_history_in_detail && ret=0
                ;;
            (args)
                case $words[1] in
                    (+)
                        _buffer_ring_reverse && ret=0
                        ;;
                    (-)
                        _buffer_ring_normal && ret=0
                        ;;
                    (=)
                        _buffer_ring_normal && ret=0
                        ;;
                esac
                ;;
        esac

        #IFS=$OLDIFS
        return ret
    }

    _buffer_ring_normal()
    {
        IFS=$'\n'
        local -a _c
        _c=(
        '0:'"${ENHANCD_CDQ[1]/$HOME/~}"
        '1:'"${ENHANCD_CDQ[2]/$HOME/~}"
        '2:'"${ENHANCD_CDQ[3]/$HOME/~}"
        '3:'"${ENHANCD_CDQ[4]/$HOME/~}"
        '4:'"${ENHANCD_CDQ[5]/$HOME/~}"
        '5:'"${ENHANCD_CDQ[6]/$HOME/~}"
        '6:'"${ENHANCD_CDQ[7]/$HOME/~}"
        '7:'"${ENHANCD_CDQ[8]/$HOME/~}"
        '8:'"${ENHANCD_CDQ[9]/$HOME/~}"
        '9:'"${ENHANCD_CDQ[10]/$HOME/~}"
        )
        _describe -t commands Commands _c
    }

    _buffer_ring_reverse()
    {
        IFS=$'\n'
        local -a _c
        _c=(
        '0:'"${ENHANCD_CDQ[1]/$HOME/~}"
        '1:'"${ENHANCD_CDQ[10]/$HOME/~}"
        '2:'"${ENHANCD_CDQ[9]/$HOME/~}"
        '3:'"${ENHANCD_CDQ[8]/$HOME/~}"
        '4:'"${ENHANCD_CDQ[7]/$HOME/~}"
        '5:'"${ENHANCD_CDQ[6]/$HOME/~}"
        '6:'"${ENHANCD_CDQ[5]/$HOME/~}"
        '7:'"${ENHANCD_CDQ[4]/$HOME/~}"
        '8:'"${ENHANCD_CDQ[3]/$HOME/~}"
        '9:'"${ENHANCD_CDQ[2]/$HOME/~}"
        )
        _describe -t commands Commands _c
    }

    _listup_history()
    {
        local -a _c
        _c=(`enhancd_logview | sed 's|.*/||g'`)
        _describe -t others "History" _c
    }

    _listup_history_in_detail()
    {
        local -a head
        local -a full
        local -a _c

        head=(`enhancd_logview | sed 's|.*/||g'`)
        full=(`enhancd_logview`)

        local i
        for ((i=1; i<${#head[@]}; i++))
        do
            _c+=(
            "$head[$i]"':'"$full[$i]"
            )
        done
        _describe -t others "History" _c
    }

    _no_arguments()
    {
        local -a _candidates
        local -i num
        IFS=$'\n'
        num=$(($ENHANCD_COMP_LIMIT/2))
        _candidates+=(`cat "$ENHANCD_DATABASE" | sort | uniq -c | sort -nr | head -n ${num} | sed 's|.*/||g'`)
        _candidates+=(`enhancd_logview -r | head -n $num | sed 's|.*/||g'`)

        local -a _c
        _c=(
        '+:Go back like a web-browser (0,9,8,...)'
        '-:Forward like a web-browser (0,1,2,...)'
        )

        #TODO directory only...
        _cd_org
        _describe -t commands "Commands" _c
        _describe -t others "History" _candidates
        #if ls -F -1 | grep -q "/$"; then
        #    _files -/
        #    _describe -t commands "Commands" _c
        #fi
        #_describe -t others "History" _candidates
        #if ls -F -1 | grep -qv "/$"; then
        #    _describe -t commands "Commands" _c
        #fi
    }
    autoload -Uz compinit
    compinit
    compdef _cd cd
    function _cd_org()
    {
        _cd_options () {
            _arguments -s '-q[quiet, no output or use of hooks]' '-s[refuse to use paths with symlinks]' '(-P)-L[retain symbolic links ignoring CHASE_LINKS]' '(-L)-P[resolve symbolic links as CHASE_LINKS]'
        }
        setopt localoptions nonomatch
        local expl ret=1 curarg
        integer argstart=2 noopts
        if (( CURRENT > 1 ))
        then
            while [[ $words[$argstart] = -* && argstart -lt CURRENT ]]
            do
                curarg=$words[$argstart]
                [[ $curarg = -<-> ]] && break
                (( argstart++ ))
                [[ $curarg = -- ]] && noopts=1  && break
            done
        fi
        if [[ CURRENT -eq $((argstart+1)) ]]
        then
            local rep
            rep=(${~PWD/$words[$argstart]/*}~$PWD(-/))
            rep=(${${rep#${PWD%%$words[$argstart]*}}%${PWD#*$words[$argstart]}})
            (( $#rep )) && _wanted -C replacement strings expl replacement compadd -a rep
        else
            if [[ "$PREFIX" = (#b)(\~|)[^/]# && ( -n "$match[1]" || ( CURRENT -gt 1 && ! -o cdablevars ) ) ]]
            then
                _directory_stack && ret=0
            fi
            local -a tmpWpath
            if [[ $PREFIX = (|*/)../* ]]
            then
                local tmpprefix
                tmpprefix=$(cd ${PREFIX%/*} >&/dev/null && print $PWD)
                if [[ -n $tmpprefix ]]
                then
                    tmpWpath=(-W $tmpprefix)
                    IPREFIX=${IPREFIX}${PREFIX%/*}/
                    PREFIX=${PREFIX##*/}
                fi
            fi
            if [[ $PREFIX != (\~|/|./|../)* && $IPREFIX != ../* ]]
            then
                local tmpcdpath alt
                alt=()
                tmpcdpath=(${${(@)cdpath:#.}:#$PWD})
                (( $#tmpcdpath )) && alt=('path-directories:directory in cdpath:_path_files -W tmpcdpath -/')
                if [[ -o cdablevars && -n "$PREFIX" && "$PREFIX" != <-> ]]
                then
                    if [[ "$PREFIX" != */* ]]
                    then
                        alt=("$alt[@]" 'named-directories: : _tilde')
                    else
                        local oipre="$IPREFIX" opre="$PREFIX" dirpre dir
                        dirpre="${PREFIX%%/*}/"
                        IPREFIX="$IPREFIX$dirpre"
                        eval "dir=( ~$dirpre )"
                        PREFIX="${PREFIX#*/}"
                        [[ $#dir -eq 1 && "$dir[1]" != "~$dirpre" ]] && _wanted named-directories expl 'directory after cdablevar' _path_files -W dir -/ && ret=0
                        PREFIX="$opre"
                        IPREFIX="$oipre"
                    fi
                fi
                [[ CURRENT -ne 1 || ( -z "$path[(r).]" && $PREFIX != */* ) ]] && alt=("${cdpath+local-}directories:${cdpath+local }directory:_path_files ${(j: :)${(@q)tmpWpath}} -/" "$alt[@]")
                if [[ CURRENT -eq argstart && noopts -eq 0 && $PREFIX = -* ]] && zstyle -t ":completion:${curcontext}:options" complete-options
                then
                    alt=("$service-options:$service option:_cd_options" "$alt[@]")
                fi
                _alternative "$alt[@]" && ret=0
                return ret
            fi
            [[ CURRENT -ne 1 ]] && _wanted directories expl directory _path_files $tmpWpath -/ && ret=0
            return ret
        fi
    }
fi

### Misc {{{1

# Add history
# Use PROMPT_COMMAND or precmd
if is_bash; then
    if echo "$PROMPT_COMMAND" | grep -q -v "enhancd_addhistory"; then
        PROMPT_COMMAND="enhancd_addhistory;$PROMPT_COMMAND"
    fi
elif is_zsh; then
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd enhancd_addhistory
fi

# Main at startup
#
if [ -f $ENHANCD_DATABASE ]; then
    if [ "${ENHANCD_REFRESH_STARTUP:-true}" = 'true' ]; then
        enhancd_refresh
    fi
    enhancd_initialize
    #unset -f enhancd_initialize
    #enhancd_cd $HOME
    if [ "${ENHANCD_HOME_STARTUP:-true}" = 'true' ]; then
        enhancd_cd $HOME
    fi
else
    enhancd_reset
fi
# vim:fdm=marker expandtab fdc=3 ts=4 sw=4 sts=4:
