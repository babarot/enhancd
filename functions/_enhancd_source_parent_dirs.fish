function _enhancd_source_parent_dirs
    if test "$ENHANCD_ENABLE_DOUBLE_DOT" = false
        echo ".."
        return 0
    end

    _enhancd_filepath_get_parent_dirs "$PWD"
end
