set -g log ~/.cdlog

function enhancd
    set filter (available $FILTER)
    if empty $filter
        die '$FILTER not found'
    end

    test -f $log; or touch $log

    if test -d "$argv[1]"
        builtin cd $argv[1]
    else
        interface $argv
    end
end
alias cd enhancd

function interface
    if empty $argv
        begin
            has "ghq"; and ghq list -p
            cat $log
            echo $HOME
        end | reverse | unique | eval $filter | read dir

        not empty $dir; and builtin cd $dir
    else
        set res (cdnarrow $argv[1])
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

function cdlist
    begin
        cat $log | reverse
        has "ghq"; and ghq list -p
    end | unique
end

function cdnarrow
    cdlist | awk '/\/.?'"$argv[1]"'[^\/]*$/{print $0}' ^/dev/null
end

function cdcount
    cdnarrow $argv[1] | grep -c ""
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
    set file (cat $log)
    for i in $file
        test -d $i; and echo $i
    end >$log
    pwd >>$log
end
