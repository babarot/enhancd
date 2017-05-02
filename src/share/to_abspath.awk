BEGIN {
    # If dir is a slash, return a slash and exit
    if (dir == "/") {
        print "/"
        exit
    }
    if (cwd !~ dir) {
        exit
    }

    # pos is a position of dir in cwd
    pos = rindex(cwd, dir)

    # If it is not find the dir in the cwd, then exit
    if (pos == 0) {
        print cwd
        exit
    }

    # convert the divided directory name to the absolute path
    # that the directory name is contained
    print erase(cwd, pos+length(dir))
}

# erase erases the part of the path
function erase(str, pos) {
    return substr(str, 1, pos-1)
}

# rindex returns the index of the last instance of find in string,
# or 0 if find is not present
function rindex(string, find, k, ns, nf) {
    ns = length(string)
    nf = length(find)
    for (k = ns+1-nf; k >= 1; k--) {
        if (substr(string, k, nf) == find) {
            if (k > 1 && substr(string, k-1, 1) == "/")
                return k
            else if (k == 1)
                return k
        }
    }
}
