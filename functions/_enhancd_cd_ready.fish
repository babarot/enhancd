function _enhancd_cd_ready
    test -n "$ENHANCD_AWK_CMD"
   ; and test -n "$ENHANCD_CURRENT_FILTER"
   ; and test -n "$ENHANCD_DIRECTORIES"
   ; and set -Ux _ENHANCD_READY 1
    return $status
end
