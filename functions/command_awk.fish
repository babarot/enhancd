# Returns gawk if found, else awk
function command_awk
    set -l awk_cmd

    if type -q gawk
        set awk_cmd "gawk"
    else
        set awk_cmd "awk"
    end

    if set -q argv[1]
        $awk_cmd $argv
    else
        $awk_cmd ""
    end
end