# _enhancd_filter_reverse reverses a stdin contents
function _enhancd_filter_reverse
    read --list --local str
    echo $str[-1..1]
end
