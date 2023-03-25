function enhancd
    set -l arg
    set -l args
    set -l opts
    set -l code 0

    if not _enhancd_cd_ready
        if not set -q argv[1]
            _enhancd_cd_builtin "$HOME"
        else
            _enhancd_cd_builtin "$argv"
        end
        return $status
    end

    # set indice to the first element
    set -l i 1

    while [ $i -le (count $argv) ]
        switch $argv[$i]
            case "--help"
                _enhancd_ltsv_open \
                  | _enhancd_command_awk -f "$ENHANCD_ROOT/lib/help.awk"

            case "$ENHANCD_HYPHEN_ARG"
                # If a hyphen is passed as the argument,
                # searchs from the last 10 directory items in the log
                set -a args (_enhancd_source_mru "$argv[2]" | _enhancd_filter_interactive)
                set code $status

            case '-'
                set -a args "$OLDPWD"

            case "$ENHANCD_DOT_ARG"
                set -a args (_enhancd_source_parent_dirs "$argv[2]" | _enhancd_filter_interactive)
                set code $status

            case '..'
                set -a args ".."

            case "$ENHANCED_HOME_ARG"
                set -a args (_enhancd_source_home | _enhancd_filter_interactive)
                set code $status

            case '--'
                set -a opts "$argv[1]"
                set -a args (_enhancd_source_history "$argv[2]" | _enhancd_filter_interactive)
                set code $status

            case '-*' '--*'
                if _enhancd_helper_is_default_flag "$argv[1]"
                    set -a opts "$argv[1]"
                else
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
                    _enhancd_command_run "$func" "$arg" | _enhancd_filter_interactive
                end

            case '*'
                set -a args (_enhancd_source_history "$argv[1]" | _enhancd_filter_interactive)

        end
        set i (math "$i + 1")
    end

    switch (count $argv)
        case '0'
            set -a args (_enhancd_source_home | _enhancd_filter_interactive)
            set code $status
    end

    switch "$code"
        case '0'
            _enhancd_cd_builtin $opts $args
            return $status
        case '*'
            return 1
    end
end
