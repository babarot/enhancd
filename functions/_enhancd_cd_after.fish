function _enhancd_cd_after
    set -l list
    set list (_enhancd_history_update)

    if test -n "$list"
        # Workaround to print one folder per line
        string replace -a ' ' '\n' $list >"$ENHANCD_DIR/enhancd.log"
    end

    if test -n "$ENHANCD_HOOK_AFTER_CD"
        eval "$ENHANCD_HOOK_AFTER_CD"
    end
end
