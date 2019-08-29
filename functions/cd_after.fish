function cd_after
    set -l list
    set list (history_update)

    if [ -n "$list" ]
        # Workaround to print one folder per line
        string replace -a ' ' '\n' $list >"$ENHANCD_DIR/enhancd.log"
    end

    if [ -n "$ENHANCD_HOOK_AFTER_CD" ]
        eval "$ENHANCD_HOOK_AFTER_CD"
    end
end