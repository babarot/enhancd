function _enhancd_filepath_get_dirs_in_cwd
    # https://github.com/sharkdp/fd
    if type -q fd
        # using fd command gives better results than find command
        command fd --type d --hidden -E .git
        return $status
    end

    # https://unix.stackexchange.com/questions/611685/finding-all-directories-except-hidden-ones
    # cut is needed fot triming "./" from the output
    LC_ALL=C command find . ! -name . \( -name '.*' -prune -o -type d -print \) | cut -c3-
end
