# _enhancd_filter_reverse reverses a stdin contents
function _enhancd_filter_reverse
    set -l lines
    if test -n "$argv[1]"; and test -f "$argv[1]"
        set lines "$argv[1]"
    else
        read -z --list lines
    end
    for line in $lines[-1..1]
        echo $line
    end
end
