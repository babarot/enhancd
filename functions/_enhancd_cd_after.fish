function _enhancd_cd_after
    # Don't split on newlines throughout this function:
    set -l IFS ""

    set -l list (_enhancd_history_update)

    if test -n "$list"
        echo "$list" >"$ENHANCD_DIR/enhancd.log"
    end

    if test -n "$ENHANCD_HOOK_AFTER_CD"
        eval "$ENHANCD_HOOK_AFTER_CD"
    end
end
