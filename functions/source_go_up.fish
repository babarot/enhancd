function source_go_up
    if [ "$ENHANCD_DISABLE_DOT" = 1 ]
        echo ".."
        return 0
    end

        filepath_list_step "$PWD" \
        | command_grep "$argv[1]" \
        | filter_interactive \
        | filepath_abs

    # Returns false if filepath_abs fails
    # filepath_abs returns false if filter_interactive doesn't output anything
    if [ "$status" = 1 ]
        if [ -n $argv[1] ]
            # Returns false if an argument is given
            return $_ENHANCD_FAILURE
        else
            # Returns true when detecting to press Ctrl-C in selection
            return $_ENHANCD_SUCCESS
        end
    end
end
