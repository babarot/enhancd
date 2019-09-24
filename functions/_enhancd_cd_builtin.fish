function _enhancd_cd_builtin
    set -l code 0
    _enhancd_cd_before
    builtin cd $argv
    set code $status
    _enhancd_cd_after

    return $code
end