function _enhancd_command_run
    set -l cond $argv[1]
    if not set -q $SHELL
        set SHELL "fish"
    end
    $SHELL -c $cond
    return $status
end
