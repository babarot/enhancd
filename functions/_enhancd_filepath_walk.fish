function _enhancd_filepath_walk
    set -a dirs $PWD (_enhancd_filepath_get_parent_dirs)

    for dir in $dirs
        command find "$dir" -maxdepth 1 -type d -name '\.*' -prune -o -type d -print
    end
end
