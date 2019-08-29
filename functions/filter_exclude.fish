function filter_exclude
    command_grep -v -x "$argv[1]"
    or true
end
