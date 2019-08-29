function source_default
    if [ "$ENHANCD_DISABLE_HOME" = 1 ]
        echo "$HOME"
        return 0
    end
    history_list | filter_interactive "$list"

end
