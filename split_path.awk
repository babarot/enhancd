
# has_prefix tests whether the string s begins with pre.
function has_prefix(s, pre,        pre_len, s_len) {
    pre_len = length(pre)
    s_len   = length(s)

    return pre_len <= s_len && substr(s, 1, pre_len) == pre
}

function join(array, start, end, sep,    result, i)
{
    if (sep == "")
       sep = " "
    else if (sep == SUBSEP) # magic value
       sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++)
        result = result sep array[i]
    return result
}

# isabs returns true if the path is absolute.
function isabs(pathname) {
    return length(pathname) > 0 && has_prefix(pathname, "/")
}

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
        print join(arr, 0, i, "/")
    }
}
