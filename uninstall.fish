# enhancd-fish uninstall hook
#
# You can use this file to do custom cleanup when the package is uninstalled.
# You can use the variable $path to access the package path.

switch (command uname)
    case Darwin \*BSD
        rm -rf $ENHANCD_DIR
    case \*
        rm --force --recursive --dir $ENHANCD_DIR
end