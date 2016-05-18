BEGIN {
    flag = 0;
}

{
    ++a[$0];
    if (a[$0] > 1)
        flag = 1;
}

END {
    exit flag == 1 ? 0 : 1;
}
