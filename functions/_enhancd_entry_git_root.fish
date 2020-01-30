function _enhancd_entry_git_root
    if git rev-parse --is-inside-work-tree 2> /dev/null
        echo (git rev-parse --show-toplevel) 2> /dev/null
    else
        return
    end | _enhancd_filter_exclude "true"
end