function _enhancd_filter_trim
    set --query argv[1] || return
    __enhancd::filter::replace "$argv[1]"
end
