# Returns true if the argument exists in PATH such as "which" command
function command_which
    if [ -z "$argv[1]" ] || ! type -q "$argv[1]"
        return 1
    else
        return 0
    end
end