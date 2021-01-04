function _enhancd_filepath_abs
    # local cwd dir
    set -l cwd (string match --regex '^/.*/' "$PWD")
    set -l dir "$argv"

    if test -z "$dir"; or test -p /dev/stdin
        read -z dir
        # trim newline for awk scripts to works correctly
        set dir (string trim -c \n "$dir")
    end

    if test -z "$dir"
        return 1
    end

    _enhancd_command_awk \
        -f "$ENHANCD_ROOT/lib/to_abspath.awk" \
        -v cwd="$cwd" \
        -v dir="$dir"
end
