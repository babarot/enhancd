basedir=~/.enhancd
logfile=enhancd.log
log=$basedir/$logfile

die() {
    echo "$1" 1>&2
}

unique() {
    awk '!a[$0]++' "${1:--}"
}

reverse() {
    perl -e 'print reverse <>'
}

available() {
    local c i

    c="$(echo "$1" | tr ":" "\n")"
    for i in ${c[@]}
    do
        if has $i; then
            echo $i
            return 0
        else
            continue
        fi
    done

    return 1
}

empty() {
    [ $# -eq 0 ] && return 0
    [ -z "$1" ]
    return $?
}

has() {
    type "$1" >/dev/null 2>/dev/null
    return $?
}

cd::list()
{
    {
        cat $log | reverse
        has "ghq" && ghq list -p
    } | unique
}

cd::narrow()
{
    cd::list | awk '/\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null
}

cd::enumrate()
{
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

cd::refresh()
{
    while read line
    do
        [ -d "$line" ] && echo "$line"
    done <"$log"
}

cd::makelog()
{
    if [ ! -d $basedir ]; then
        mkdir -p $basedir
    fi

    # create ~/.enhancd/enhancd.log
    touch $log

    esc=$basedir/enhancd.$(date +%d%m%y)$$$RANDOM
    $1 >"$esc"

    # backup
    cp -f "$log" $basedir/enhancd.backup
    rm "$log"

    mv "$esc" "$log" 2>/dev/null
    if [ $? -eq 0 ]; then
        rm "$basedir"/enhancd.backup
    else
        cp -f "$basedir"/enhancd.backup "$log"
    fi
}

cd::assemble()
{
    cd::enumrate
    cat "$log"
    pwd
}

cd:add()
{
    pwd >>"$log"
}

cd::interface()
{
    filter="$(available "$ENHANCD_FILTER")"
    if empty "$ENHANCD_FILTER"; then
        die '$ENHANCD_FILTER not set'
        return 1
    elif empty "$filter"; then
        die "$ENHANCD_FILTER is invalid \$ENHANCD_FILTER"
        return 1
    fi

    if empty "$1"; then
        target=$(
            {
                has "ghq" && ghq list -p
                cat "$log"
                echo "$HOME"
            } | reverse | unique | eval "$filter"
        )
        empty "$target" || builtin cd "$target"
    else
        res="$(cd::narrow "$1")"
        wc="$(echo "$res" | grep -c "")"
        case "$wc" in
            0 )
                die "an fatal error"
                return 1
                ;;
            1 )
                if [ -d "$res" ]; then
                    builtin cd "$res"
                else
                    die "$1: no such file or directory"
                    return 1
                fi
                ;;
            * )
                dir="$(echo "$res" | eval "$filter")"
                builtin cd "$dir"
                ;;
        esac
    fi
}

cd() {
    cd::makelog "cd::refresh"

    if [ -p /dev/stdin ]; then
        builtin cd $(cat -)
    elif [ -d "$1" ]; then
        builtin cd "$1"
    else
        if empty "$ENHANCD_FILTER"; then
            ENHANCD_FILTER="fzf:peco:percol:gof:pick:icepick:sentaku:selecta"
            export ENHANCD_FILTER
        fi

        cd::interface "$1"
    fi

    cd::makelog "cd::assemble"
}

if [ -n "$ZSH_VERSION" ]; then
    add-zsh-hook chpwd cd:add
fi
