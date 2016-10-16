__enhancd::sync()
{
    local dir OLDIFS="$IFS"
    IFS=$'\n'

    enhancd_dirs=( $(
    {
        # Returns a list that was decomposed with a slash
        # to the directory path that visited just before
        # e.g., /home/lisa/src/github.com
        # -> /home
        # -> /home/lisa
        # -> /home/lisa/src
        # -> /home/lisa/src/github.com
        __enhancd::path::step_by_step "$PWD" | __enhancd::utils::reverse
        find "$PWD" -maxdepth 1 -type d | __enhancd::utils::grep -v "\/\."
        for dir in "${enhancd_dirs[@]}"
        do
            echo "$dir"
        done
        echo "$PWD"
    } \
        |  __enhancd::utils::reverse \
        | __enhancd::utils::unique \
        | __enhancd::utils::reverse
    ) )
    IFS="$OLDIFS"
    enhancd_dirs+=("$PWD")

    (
        IFS=$'\n'
        {
            for dir in "${enhancd_dirs[@]}"
            do
                echo "$dir"
            done >|"$ENHANCD_DIR/enhancd.log"
        } &
    )
}
