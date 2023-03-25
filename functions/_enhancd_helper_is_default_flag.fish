function _enhancd_helper_is_default_flag
    set -l opt $argv[1]
    switch $SHELL
        case "*bash"
            switch "$opt"
                case "-P" "-L" "-e" "-@"
                    return 0
            end

        case "*zsh"
            switch "$opt"
                case "-q" "-s" "-L" "-P"
                    return 0
            end
    end
    return 1
end
