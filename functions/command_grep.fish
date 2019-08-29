# Overrides grep command
function command_grep
    if [ -n "$argv[1]" ] && [ -f "$argv[1]" ]
        cat "$argv[1]"
    else
        cat <&0
    end \
     | command grep -E $argv 2>/dev/null
end