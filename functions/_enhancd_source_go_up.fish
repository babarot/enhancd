function _enhancd_source_go_up
    if test "$ENHANCD_DISABLE_DOT" = 1
        echo ".."
        return 0
    end

    _enhancd_filepath_list_step "$PWD" \
        | _enhancd_command_grep "$argv[1]" \
        | _enhancd_filter_interactive \
        | _enhancd_filepath_abs

    # Returns false if _enhancd_filepath_abs fails
    # _enhancd_filepath_abs returns false if _enhancd_filter_interactive doesn't output anything
    if test "$status" = 1
        if test -n $argv[1]
            # Returns false if an argument is given
            return $_ENHANCD_FAILURE
        else
            # Returns true when detecting to press Ctrl-C in selection
            return $_ENHANCD_SUCCESS
        end
    end
end
