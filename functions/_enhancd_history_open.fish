function _enhancd_history_open
    if [ -f $ENHANCD_DIR/enhancd.log ]
        cat "$ENHANCD_DIR/enhancd.log"
        return $status
    end
    return 1
end
