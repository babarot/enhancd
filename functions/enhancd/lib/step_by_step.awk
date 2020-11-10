BEGIN {
    count = gsub(/\//, "/", dir);
    for (i = 0; i < count; i++) {
        gsub(/\/[^\/]*$/, "", dir);
        if (dir == "")
            print "/";
        else
            print dir;
    }
}
