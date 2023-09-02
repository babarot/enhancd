function _enhancd_cd_ready
    _enhancd_helper_parse_filter_string "$ENHANCD_FILTER" 2 >/dev/null
   ; and test -n $ENHNCD_DIRECTORIES
   ; and set -Ux _ENHANCD_READY 1
    return $status
end
