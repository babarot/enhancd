function ltsv_parse
    set -l args
    set -l query

    set -l i 1
    while [ $i -le (count argv) ]
        switch "$argv[$i]"
            case "-q"
                set -l query $argv[(math "$i + 1")]
                shift
            case "-v"
                set -a args "-v" $argv[(math "$i + 1")]
            case "-f"
                set -a args "-f" "$ENHANCD_ROOT/lib/ltsv.awk"
                set -a args "-f" $argv[(math "$i + 1")]
                set query ""
        end
        set i (math "$i + 1")
    end

    set -l default_query '{print $0}'
    set -l ltsv_script (cat "$ENHANCD_ROOT/lib/ltsv.awk")

    if ! set -q query
        set query $default_query
    end
    set -l awk_scripts "$ltsv_script $query"

    command_awk $args "$awk_scripts"
end
