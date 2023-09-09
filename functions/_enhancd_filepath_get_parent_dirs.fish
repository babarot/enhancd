# Lists a path step-wisely
function _enhancd_filepath_get_parent_dirs
    if not set -q argv[1]
        set argv[1] "$PWD"
    end

    "$ENHANCD_AWK_CMD" \
        -f "$ENHANCD_ROOT/lib/step_by_step.awk" \
        -v dir="$argv[1]"
end
