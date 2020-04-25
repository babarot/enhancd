function _enhancd_filter_exclude_commented
    _enhancd_command_grep -v -E '^(//|#)'
   ; or true
end
