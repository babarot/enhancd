# Returns gawk if found, else awk
function _enhancd_command_awk
    if type -q gawk
        echo "gawk"
    else
        echo "awk"
    end
end
