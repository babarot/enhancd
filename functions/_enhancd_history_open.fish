function _enhancd_history_open
    # if test -f $ENHANCD_DIR/enhancd.log
    #     command cat "$ENHANCD_DIR/enhancd.log"
    #     return $status
    # end
    echo $ENHANCD_DIRECTORIES
    # for item in $ENHANCD_DIRECTORIES
    #     echo "$item"
    # end

    return $status
    # return 1
end

function set_mem_var
    set -e ENHANCD_DIRECTORIES
    set -Ux ENHANCD_DIRECTORIES
    while read -l line
        set -a ENHANCD_DIRECTORIES "$line"
    end < ~/.enhancd/enhancd.log
end
