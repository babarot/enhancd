__enhancd::entry::git::root()
{
    if git rev-parse --is-inside-work-tree 2> /dev/null && [[ $(git rev-parse --show-toplevel) != $PWD ]]; then
        echo $(git rev-parse --show-toplevel) 2> /dev/null
    else
        return
    fi | __enhancd::filter::exclude "true"
}
