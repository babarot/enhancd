function _enhancd_filter_fuzzy
    read --list --local stdin
    if test -z "$argv[1]"
        echo $stdin
    else
        set -l dirs (
            string join \n -- $stdin | _enhancd_command_awk \
            -f "$ENHANCD_ROOT/lib/fuzzy.awk" \
            -v search_string="$argv[1]"
        )
        echo $dirs
    end
end
