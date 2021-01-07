function _enhancd_history_open
    if test -f $ENHANCD_DIR/enhancd.log
        command cat "$ENHANCD_DIR/enhancd.log"
        return $status
    end
    return 1
end
