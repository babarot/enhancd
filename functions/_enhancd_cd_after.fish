function _enhancd_cd_after
    # Don't split on newlines throughout this function:
    set -l IFS ""

    set -l list (string split \n -- (_enhancd_history_update))
    if test -n "$list"
        set -Ux ENHANCD_DIRECTORIES $list
    end

    if test -n "$ENHANCD_HOOK_AFTER_CD"
        eval "$ENHANCD_HOOK_AFTER_CD"
    end
end
