BEGIN {
    FS = "\t";
    len = 0;

    # Print header
    print "Usage: cd [OPTIONS] [dir]"
    print ""
    print "OPTIONS:"
}

# Skip commented line starting with # or //
/^(#|\/\/)/ { next }

{
    len++;

    condition = ltsv("condition")
    if (condition != "") {
        command = sprintf("%s &>/dev/null", condition);
        code = system(command)
        close(command);
        if (code == 1) { next }
    }

    short = ltsv("short")
    long  = ltsv("long")
    desc  = ltsv("desc")

    if (short == "") {
        printf "  %s  %-15s %s\n", "  ", long, desc
    } else if (long == "") {
        printf "  %s  %-15s %s\n", short, "", desc
    } else {
        printf "  %s, %-15s %s\n", short, long, desc
    }
}

END {
    # Print footer
    if (len == 0) { print "  No available options now" }
    print ""
    printf "Version: %s\n", ENVIRON["_ENHANCD_VERSION"]
}

function ltsv(key) {
    for (i = 1; i <= NF; i++) {
        match($i, ":");
        xs[substr($i, 0, RSTART)] = substr($i, RSTART+1);
    };
    return xs[key":"];
}
