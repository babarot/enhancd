function enhancd
    set -l arg
    set -l args
    set -l opts
    set -l code 0

    if not _enhancd_source_is_available
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
                _enhancd_help

            case "$ENHANCD_HYPHEN_ARG"
                # If a hyphen is passed as the argument,
                # searchs from the last 10 directory items in the log
                set -a args (_enhancd_source_mru "$argv[2]")
                set code $status

            case '-'
                set -a args "$OLDPWD"

            case "$ENHANCD_DOT_ARG"
                set -a args (_enhancd_source_go_up "$argv[2]")
                set code $status

            case '..'
                set -a args ".."

            case "$ENHANCED_HOME_ARG"
                set -a args (_enhancd_source_default)
                set code $status

            case '--'
                set -a opts "$argv[1]"
                set -a args (_enhancd_source_argument "$argv[2]")
                set code $status

            case '-*' '--*'
                if _enhancd_flag_is_default "$argv[1]"
                    set -a opts "$argv[1]"
                else
                    set -a args (_enhancd_flag_parse "$argv[1]")
                    set code $status
                end

            case '*'
                set -a args (_enhancd_source_argument "$argv[1]")

        end
        set i (math "$i + 1")
    end

    switch (count $argv)
        case '0'
            set -a args (_enhancd_source_default)
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
