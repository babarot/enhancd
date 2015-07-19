log=~/.cdlog

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
    type "$1" >/dev/null
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
    touch "$log"

    while read line
    do
        [ -d "$line" ] && echo "$line"
    done <"$log"
}

cd::makelog()
{
    $1 >/tmp/log.$$
    rm "$log"
    mv /tmp/log.$$ "$log"
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
    filter="$(available "$FILTER")"
    if empty "$filter"; then
        die '$FILTER not set'
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

    [ ! -f "$log" ] && touch "$log"

    if [ -p /dev/stdin ]; then
        builtin cd $(cat -)
    elif [ -d "$1" ]; then
        builtin cd "$1"
    else
        if [ -z "$FILTER" ]; then
            FILTER=fzf:peco:gof:hf
        fi

        cd::interface "$1"
    fi

    cd::makelog "cd::assemble"
}

if [ -n "$ZSH_VERSION" ]; then
    add-zsh-hook chpwd cd:add
fi
