set -g basedir ~/.enhancd
set -g logfile enhancd.log
set -g log $basedir/$logfile


function enhancd
    test -f $log; or touch $log

    if test -p /dev/stdin
        read dir
        test -d "$dir"; and builtin cd "$dir"
    else if test -d "$argv[1]"
        builtin cd "$argv[1]"
    else
        if empty "$ENHANCD_FILTER"
            set -U ENHANCD_FILTER fzf:peco:percol:gof:hf
        end

        cd::interface $argv
    end
end

function cd::interface
    set -l filter (available $ENHANCD_FILTER)
    if empty "$ENHANCD_FILTER"
        die '$ENHANCD_FILTER not set'
    else if empty "$filter"
        die "$ENHANCD_FILTER is invalid \$ENHANCD_FILTER"
    end

    if empty $argv
        begin
            has "ghq"; and ghq list -p
            cat $log
            echo $HOME
        end | reverse | unique | eval $filter | read dir

        not empty $dir; and builtin cd $dir
    else
        set -l res (cd::narrow "$argv[1]")
        switch (count $res)
            case 0
                echo "$argv[1]: no such file or directory"
                return 1
            case 1
                builtin cd $res
            case '*'
                for i in $res
                    echo $i
                end | eval $filter | read dir
                builtin cd $dir
        end
    end
end

function cd::list
    begin
        cat $log | reverse
        has "ghq"; and ghq list -p
    end | unique
end

function cd::narrow
    cd::list | awk '/\/.?'"$argv[1]"'[^\/]*$/{print $0}' ^/dev/null
end

function unique
    awk '!a[$0]++' -
end

function reverse
    perl -e 'print reverse <>'
end

function has
    type -q $argv[1]
end

function die
    # TODO:
    echo "$argv"
    exit 1
end

function available
    echo $argv | read -a ary
    for i in $ary
        if has $i
            echo $i
            return 0
        else
            continue
        end
    end
end

function empty
    if test (count $argv) = 0
        return 0
    end
    test -z $argv[1]
end

function cd::add_log --on-variable PWD
    test -d $basedir; or mkdir -p $basedir
    touch $log

    set -l file (cat $log)

    # refresh
    for i in $file
        test -d $i; and echo $i
    end >$log

    pwd >>$log
end
