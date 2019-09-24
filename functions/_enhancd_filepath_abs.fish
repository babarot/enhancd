function _enhancd_filepath_abs
    # local cwd dir
    set -l cwd (string match --regex '^/.*/' "$PWD")
    set -l dir "$argv"

    if [ -z "$dir" ] || [ -p /dev/stdin ]
        read -z dir
        # trim newline for awk scripts to works correctly
        string trim -c '\n' "$dir"
    end

    if [ -z "$dir" ]
        return 1
    end

    echo "cwd : -$cwd- -- dir : -$dir-" >$HOME/debug.txt

    _enhancd_command_awk \
        -f "$ENHANCD_ROOT/lib/to_abspath.awk" \
        -v cwd="$cwd" \
        -v dir="$dir"
end