# Splits a list of commands joined by the colon, found in PATH environment variables
function filepath_split_list
    set -l str

    if [ -z "$argv[1]" ]
        return 1
    end

    # str should be list like "a:b:c" concatenated by a colon
    set str (string join ':' $argv[1])

    while [ -n "$str" ]
        for item in (string split ':' $str)
            if command_which "$item"
                echo $item
                return 0
            else
                continue
            end
        end
    end

    return 1
end