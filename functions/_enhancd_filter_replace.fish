function _enhancd_filter_replace
    if ! set -q argv[1]
        return 1
    else
        set -l old $argv[1]
    end

    if ! set -q argv[2]
        set -l new $argv[2]
    else
        set -l new ""
    end

    _enhancd_command_awk \
        -v old="$old" \
        -v new="$new" \
        'sub(old, new, $0) {print $0}'
end
