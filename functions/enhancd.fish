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

            case "$ENHANCD_ARG_HYPHEN"
                # If a hyphen is passed as the argument,
                # searchs from the last 10 directory items in the log
                set -a args (_enhancd_source_mru | _enhancd_filter_interactive)
                set code $status

            case '-'
                set -a args "$OLDPWD"

            case "$ENHANCD_ARG_DOUBLE_DOT"
                set -a args (_enhancd_source_parent_dirs | _enhancd_filter_interactive)
                set code $status

            case '..'
                set -a args ".."

            case "$ENHANCD_ARG_SINGLE_DOT"
                set -a args (_enhancd_sources_current_dirs | _enhancd_filter_interactive)
                set code $status

            case '.'
                set -a args "."

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
                    set -l func cond format
                    set cond (_enhancd_ltsv_get "$opt" "condition")
                    set func (_enhancd_ltsv_get "$opt" "func")
                    set format (_enhancd_ltsv_get "$opt" "format")
                    if not _enhancd_command_run "$cond"
                        echo "$opt: defined but require '$cond'" >&2
                        return 1
                    end
                    if test -z $func
                        echo "$opt: 'func' label is required" >&2
                        return 1
                    end
                    if test -n $format; and not string match --quiet '*%*' $format
                        echo "$opt: 'format' label needs to include '%' (selected line)" >&2
                        return 1
                    end
                    _enhancd_command_run "$func" "$arg" | _enhancd_filter_interactive
                    set -l selected
                    if test -z $format
                        set selected (_enhancd_command_run "$func" | _enhancd_filter_interactive)
                    else
                        # format is maybe including $HOME etc. need magic line of 'eval printf' to expand that.
                        set selected (_enhancd_command_run "$func" | _enhancd_filter_interactive | xargs -I% echo (eval printf "%s" "$format"))
                    end
                    set code $status
                    set -a args $selected
                    break

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
