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

    awk -v search_string="$argv[1]" '
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
end

function cd::interface
    set -l filter $ENHANCD_FILTER
    if test -z $filter
        set -l filter "fzf"
    end

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

    if test -d "$argv[1]"
        builtin cd "$argv[1]"
    else
        if test -z "$argv[1]"
            set t (begin; cd::cat_log; echo "$HOME"; end | cd::list)
        else
            set t (cd::list | cd::narrow "$argv[1]")
        end

        if test -z "$t"
            set t $argv[1]
        end
        cd::interface $t
    end
end
