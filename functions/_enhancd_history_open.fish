function _enhancd_history_open
    echo $ENHANCD_DIRECTORIES
    return $status
end

function set_mem_var
    set -e ENHANCD_DIRECTORIES
    set -Ux ENHANCD_DIRECTORIES
    while read -l line
        set -a ENHANCD_DIRECTORIES "$line"
    end < ~/.enhancd/enhancd.log
end
