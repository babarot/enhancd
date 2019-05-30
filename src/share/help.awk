BEGIN {
    FS = "\t";
    len = 0;

    print "Usage: cd [OPTIONS] [dir]"
    print ""
    print "OPTIONS:"
}

# Skip commented line starting with # or //
/^(#|\/\/)/ {next}

{
    len++;
}

{
    short = key("short")
    long  = key("long")
    desc  = key("desc")

    if (short == "") {
        printf "  %s  %-15s %s\n", "  ", long, desc
    } else if (long == "") {
        printf "  %s  %-15s %s\n", short, "", desc
    } else {
        printf "  %s, %-15s %s\n", short, long, desc
    }
}

END {
    if (len == 0) { print "  No available options now" }
    printf "\n"
    printf "Version: %s\n", ENVIRON["_ENHANCD_VERSION"]
}

function key(name) {
    for (i = 1; i <= NF; i++) {
        match($i, ":");
        xs[substr($i, 0, RSTART)] = substr($i, RSTART+1);
    };
    return xs[name":"];
}
