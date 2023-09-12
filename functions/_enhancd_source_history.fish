function _enhancd_source_history
    set -l dir "$argv[1]"

    if test -d "$dir"
        echo "$dir"
        return 0
    end

    if test -n "$CDPATH"
        _enhancd_command_awk \
            -f "$ENHANCD_ROOT/lib/cdpath.awk" \
            -v cdpath="$CDPATH" \
            -v dir="$dir" && return 0
     end

    _enhancd_history_list "$dir"
end
