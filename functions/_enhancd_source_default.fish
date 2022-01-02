function _enhancd_source_default
    if test "$ENHANCD_DISABLE_HOME" = 1
        echo "$HOME"
        return 0
    end
    set -l items
    set -a items (_enhancd_entry_git_root)
    if test -z $items[1]
        set -e items[1]
    end
    set -a items (_enhancd_history_list)
    echo $items | _enhancd_filter_interactive
end
