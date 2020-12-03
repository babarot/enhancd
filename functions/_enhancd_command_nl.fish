# Reads lines from the named file or the standard input, writes the line
# with the numbering starting with 1 to the standard output such as nl command
function _enhancd_command_nl
    # d in awk's argument is a delimiter
    if set -q argv[1]
        set -l tmp $argv[1]
    else
        set -l tmp ": "
    end

    _enhancd_command_awk -v d=$tmp '
    BEGIN {
        i=1
    }
    {
        print i d $0
        i++
    }'
end
