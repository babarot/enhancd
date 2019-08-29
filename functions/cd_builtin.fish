function cd_builtin
    set -l code 0
    cd_before
    builtin cd $argv
    set code $status
    cd_after

    return $code
end