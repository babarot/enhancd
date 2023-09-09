# Splits a path with a slash
function _enhancd_filepath_split
    if not set -q argv[1]
        set $argv[1] $PWD
    end

    "$ENHANCD_AWK_CMD" \
        -f "$ENHANCD_ROOT/lib/split.awk" \
        -v arg=$argv[1]
end
