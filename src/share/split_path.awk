BEGIN {
    # check if arg is an valid path
    if (!isabs(arg)) {
        print "split_path requires an absolute path begins with a slash" >"/dev/stderr"
        exit 1
    }

    # except for the beginning of the slash
    s = substr(arg, 2)
    num = split(s, arr, "/")

    # display the beginning of the path
    print substr(arg, 1, 1)

    # decompose the path by a slash
    for (i = 1; i < num; i++) {
        if (show_fullpath == 1) {
            split(s, dirname, arr[i])
            print "/" dirname[1] arr[i]
        } else {
            print arr[i]
        }
    }
}

# has_prefix tests whether the string s begins with pre.
function has_prefix(s, pre,        pre_len, s_len) {
    pre_len = length(pre)
    s_len   = length(s)

    return pre_len <= s_len && substr(s, 1, pre_len) == pre
}

# isabs returns true if the path is absolute.
function isabs(pathname) {
    return length(pathname) > 0 && has_prefix(pathname, "/")
}
