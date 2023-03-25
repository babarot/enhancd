function _enhancd_cd_ready
    _enhancd_helper_parse_filter_string "$ENHANCD_FILTER" 2 >/dev/null
   ; and test -s $ENHANCD_DIR/enhancd.log
    return $status
end
