function _enhancd_complete
    set -l query (_enhancd_source_default)/
    if test -n "$query"
        commandline -t "$query"
    end
    commandline -f repaint
end
