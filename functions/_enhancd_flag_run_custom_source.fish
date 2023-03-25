function _enhancd_flag_run_custom_source
    set -l opt "$argv[1]"
    set -l arg "$argv[2]"
    set -l func

    set func (_enhancd_ltsv_get "$opt" "func")
    set cond (_enhancd_ltsv_get "$opt" "condition")

    if not _enhancd_command_run "$cond"
        echo "$opt: defined but require '$cond'" >&2
        return 1
    end

    if test -z $func
        echo "$opt: no such option" >&2
        return 1
    end

    $func "$arg"
end
