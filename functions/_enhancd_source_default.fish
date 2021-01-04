function _enhancd_source_default
    if test "$ENHANCD_DISABLE_HOME" = 1
        echo "$HOME"
        return 0
    end

    begin
        _enhancd_entry_git_root
        _enhancd_history_list
    end | _enhancd_filter_interactive
end
