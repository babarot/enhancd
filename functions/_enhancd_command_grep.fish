# Overrides grep command
function _enhancd_command_grep
    if test -n "$argv[1]"; and test -f "$argv[1]"
        command cat "$argv[1]"
    else
        command cat <&0
    end \
        | command grep -E $argv 2>/dev/null
end
