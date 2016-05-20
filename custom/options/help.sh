#!/bin/bash

cat <<HELP
usage: cd [OPTIONS] [dir]

OPTIONS:
HELP

cat "$ENHANCD_ROOT"/custom.json \
    | "$ENHANCD_ROOT"/.config/bin/json.sh \
    | awk -F . '
        {
            i = j = c = 1;
            max = 0;
            help = "";
            sep = "";
            options[NR] = $2;
            content[NR] = $3;
        }
        END {
            for (i = 1; i <= NR; i++) {
                if (options[i] ~ /^options/) {
                    if (options[i] == options[i+1]) {
                        if (match(content[i], /short|long|description/)) {
                            head = substr(content[i], RSTART, RLENGTH);
                            tail = substr(content[i], RSTART + RLENGTH + 1);
                            if (head == "short" && tail != "") {
                                short = tail;
                                is_short = 1;
                            }
                            if (head == "long" && tail != "") {
                                long = tail;
                                is_long = 1;
                            }
                            if (head == "description") {
                                arr_desc[c++] = tail;
                            }
                        }
                    } else {
                        if (is_short == 1 && is_long == 1) {
                            line = short ", " long;
                        }
                        if (is_short == 1 && is_long != 1) {
                            line = short;
                        }
                        if (is_short != 1 && is_long == 1) {
                            line = "    " long;
                        }
                        is_short = 0;
                        is_long = 0;
                        is_desc = 0;
                        arr_lines[j++] = line;
                    }
                }
            }
            for (i = 1; i <= NR; i++) {
                if (length(arr_lines[i]) > max)
                    max = length(arr_lines[i]);
            }
            max = max + 4;
            for (i = 1; i <= j; i++) {
                times = max - length(arr_lines[i]);
                for (cnt = 1; cnt <= times; cnt++)
                    sep = sep " ";
                print "  " arr_lines[i] sep arr_desc[i];
                sep = "";
            }
        }'

cat <<HELP

Version:  2.1.7
Author:   b4b4r07
GitHub:   https://github.com/b4b4r07/enhancd
HELP
