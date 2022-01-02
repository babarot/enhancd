function _enhancd_cd_after
    set -l list (_enhancd_history_update)

    if test -n "$list"
        # echo "$list" >"$ENHANCD_DIR/enhancd.log"
        set -Ux ENHANCD_DIRECTORIES $list
    end

    if test -n "$ENHANCD_HOOK_AFTER_CD"
        eval "$ENHANCD_HOOK_AFTER_CD"
    end
end
