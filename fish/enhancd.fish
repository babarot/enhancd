set -xg ENHANCD_DIR ~/.enhancd
set -xg ENHANCD_LOG $ENHANCD_DIR/enhancd.log

function reverse
    if test -z "$argv[1]"
        cat <&0
    else
        cat "$argv[1]"
    end | awk '
    {
        line[NR] = $0
    }
    END {
        for (i = NR; i > 0; i--) {
            print line[i]
        }
    }' 2>/dev/null
end

function unique
    if test -z "$argv[1]"
        cat <&0
    else
        cat "$argv[1]"
    end | awk '!a[$0]++' 2>/dev/null
end

function cd::split_path
    awk -v arg="$argv[1]" -f ~/.enhancd/split_path.awk
end


function cd::get_dirname
    set dir "$PWD"
    if test (count $argv) -ge 1
        set dir "$argv[1]"
    end

    set is_uniq (cd::split_path "$dir" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}')

    if test "$is_uniq" = "1"
        cd::split_path "$dir"
    else
        cd::split_path "$dir" | awk '{printf("%d: %s\n", NR, $1);}'
    end
end


function cd::add --on-variable PWD
    pwd >>"$ENHANCD_LOG"
end

function cd::cat_log
    if test -s "$ENHANCD_LOG"
        cat "$ENHANCD_LOG"
    else
        echo
    end
end

function cd::list
    if not tty >/dev/null
        cat <&0
    else
        cd::cat_log
    end | reverse | unique
end

function cd::narrow
    cat <&0 | cd::fuzzy "$argv[1]"
end

function cd::fuzzy
    if test -z "$argv[1]"
        echo "too few arguments" 1>&2
        return 1
    end

    awk -v search_string="$argv[1]" -f ~/.enhancd/fuzzy.awk 2>/dev/null
end

function cd::interface
    set -l filter "fzf"

    switch (count $argv)
        case 0
            echo "something is wrong" 1>&2
            return 1
        case 1
            if test -d "$argv[1]"
                builtin cd "$argv[1]"
            else
                echo "$argv[1]: no such file or directory" 1>&2
                return 1
            end
        case '*'
            for i in $argv
                echo "$i"
            end | eval "$filter" | read t

            if test -n "$t"
                if test -d "$t"
                    builtin cd "$t"
                else
                    echo "$t: no such file or directory" 1>&2
                    return 1
                end
            end
    end
end

function cd::cd
    if not tty >/dev/null
        set -l stdin
        read stdin
        if test -d "$stdin"
            builtin cd "$stdin"
            return $status
        else
            echo "$stdin: no such file or directory" 1>&2
            return 1
        end
    end

    if test -d "$argv[1]" -a "$argv[1]" != ".."
        builtin cd "$argv[1]"
    else
        if test -z "$argv[1]"
            set t (begin; cd::cat_log; echo "$HOME"; end | cd::list)
    else if test "$argv[1]" = '-'
            set arg2 ""
            if test (count "$argv") -ge 2
                    set t (begin; cd::list | grep -v "^$PWD\$" | reverse | tail -n 10 | reverse; end | cd::narrow "$argv[2]")
            else
                    set t (begin; cd::list | grep -v "^$PWD\$" | reverse | tail -n 10 | reverse; end)
            end
        else if test "$argv[1]" = '..'
            set arg2 ""
            if test (count $argv) -ge 2
                    set arg2 "$argv[2]"
            end
            set t (begin; cd::get_dirname "$PWD" | grep "$arg2" ; end | cd::list)
        else
            set t (cd::list | cd::narrow "$argv[1]")
        end

        if test -z "$t"
            set t $argv[1]
        end
        cd::interface $t
    end
end
