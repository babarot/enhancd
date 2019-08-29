function filepath_walk
    if ! set -q argv[1]
        set argv[1] $PWD
    end

    find "$argv[1]" -maxdepth 1 -type d \
        | command_grep -v "\/\."
end