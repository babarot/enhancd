function filter_exclude_commented
    command_grep -v -E '^(//|#)'
    or true
end
