function _enhancd_filter_trim
    if not set -q $argv[1]
        return 1
    else
        set -l str $argv[1]
    end
    __enhancd::filter::replace "$str"
end
