# Lists a path step-wisely
function filepath_list_step
    if ! set -q argv[1]
        set argv[1] "$PWD"
    end

    command_awk \
        -f "$ENHANCD_ROOT/lib/step_by_step.awk" \
        -v dir="$argv[1]"
end