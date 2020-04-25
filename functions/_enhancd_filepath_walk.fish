function _enhancd_filepath_walk
    if not set -q argv[1]
        set argv[1] $PWD
    end

    command find "$argv[1]" -maxdepth 1 -type d \
        | _enhancd_command_grep -v "\/\."
end
