# Splits a path with a slash
function filepath_split
    if ! set -q argv[1]
        set $argv[1] $PWD
    end

    command_awk \
        -f "$ENHANCD_ROOT/lib/split.awk" \
        -v arg=$argv[1]
end