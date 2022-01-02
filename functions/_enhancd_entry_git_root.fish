function _enhancd_entry_git_root
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1
       and test (git rev-parse --show-toplevel) != (pwd)
        git rev-parse --show-toplevel 2> /dev/null | _enhancd_filter_exclude "true"
    else
        return
    end
end
