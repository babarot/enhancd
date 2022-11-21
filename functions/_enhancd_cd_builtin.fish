function _enhancd_cd_builtin
    set -l code 0
    
    # in case nothing was passed in argv, default to working directory
    if test -z "$argv"
        set argv (pwd)
    end
    
    _enhancd_cd_before
    builtin cd $argv
    set code $status
    _enhancd_cd_after

    return $code
end
