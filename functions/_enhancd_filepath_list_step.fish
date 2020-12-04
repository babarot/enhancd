# Lists a path step-wisely
function _enhancd_filepath_list_step
    if not set -q argv[1]
        set argv[1] "$PWD"
    end

    _enhancd_command_awk \
        -f "$ENHANCD_ROOT/lib/step_by_step.awk" \
        -v dir="$argv[1]"
end
