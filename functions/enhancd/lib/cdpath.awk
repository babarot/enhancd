BEGIN {
    n = split(cdpath, array, ":")
    for (i = 1; i <= n; i++) {
        path = array[i] "/" dir
        if (! system("test -d " path )) {
          print path
          exit 0
        }
    }
    exit 1
}
