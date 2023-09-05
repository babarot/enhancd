# Splits a list of commands joined by the colon, found in PATH environment variables
function _enhancd_helper_parse_filter_string
    set -l str

    if test -z "$argv[1]"
        return 1
    end

    # str should be list like "a:b:c" concatenated by a colon
    set str (string join ':' $argv[1])

    while test -n "$str"
        for item in (string split ':' $str)
            set -l cmd (string split ' ' -- "$item")
            if _enhancd_command_which (string trim -- "$cmd[1]")
                echo $item
                return 0
            else
                continue
            end
        end
    end

    return 1
end
