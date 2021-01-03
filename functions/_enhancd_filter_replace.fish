function _enhancd_filter_replace
    set -q argv[1] || return   
    set -l old $argv[1]
    set -q argv[2] && set -l new $argv[2]

    _enhancd_command_awk \
        -v old="$old" \
        -v new="$new" \
        'sub(old, new, $0) {print $0}'
end
