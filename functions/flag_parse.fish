function flag_parse
    set -l opt "$argv[1]"
    set -l arg "$argv[2]"
    set -l func

    set func (ltsv_get "$opt" "func")
    set cond (ltsv_get "$opt" "condition")

    if ! command_run "$cond"
        echo "$opt: defined but require '$cond'" >&2
        return 1
    end

    if [ -z $func ]
        echo "$opt: no such option" >&2
        return 1
    end

    if command_which $func
        $func "$arg"
    else
        echo "$func: no such function defined" >&2
        return 1
    end
end
