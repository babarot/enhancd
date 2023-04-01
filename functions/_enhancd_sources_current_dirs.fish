function _enhancd_sources_current_dirs
    if test "$ENHANCD_ENABLE_SINGLE_DOT" = false
        echo "."
        return 0
    end

    _enhancd_filepath_get_dirs_in_cwd "$PWD"
end
