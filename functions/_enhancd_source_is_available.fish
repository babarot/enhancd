function _enhancd_source_is_available
    _enhancd_filepath_split_list "$ENHANCD_FILTER" 2 >/dev/null
   ; and test -s $ENHANCD_DIR/enhancd.log
    return $status
end
