function _enhancd_filepath_walk
    _enhancd_filepath_get_parent_dirs | read --list --local dirs
    set --prepend dirs $PWD

    for dir in $dirs
        command find "$dir" -maxdepth 1 -type d -name '\.*' -prune -o -type d -print
    end
end
