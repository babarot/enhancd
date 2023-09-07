function _enhancd_complete
    set -l query (_enhancd_source_home | _enhancd_filter_interactive)

    if test -n "$query"
        commandline -t "$query"
    end

    commandline --functions repaint
end
