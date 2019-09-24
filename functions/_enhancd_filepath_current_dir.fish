function _enhancd_filepath_current_dir
    if set -q PWD
        echo "$PWD"
    else
        echo (command pwd)
    end
end