BEGIN {
    FS = "\t";
}

# Skip commented line starting with # or //
/^(#|\/\/)/ {next}

function ltsv(key) {
    for (i = 1; i <= NF; i++) {
        match($i, ":");
        xs[substr($i, 0, RSTART)] = substr($i, RSTART+1);
    };
    return xs[key":"];
}
