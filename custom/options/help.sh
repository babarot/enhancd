#!/bin/bash

cat <<HELP
usage: cd [OPTIONS] [dir]

OPTIONS:
HELP

cat "$ENHANCD_ROOT"/custom.json \
    | "$ENHANCD_ROOT"/.config/bin/json.sh \
    | awk -F . '
        {
            line[NR]=$0;
            options[NR]=$2;
            content[NR]=$3;
        }
        END {
            help = "";
            for (i = 1; i < NR; i++) {
                if (options[i] ~ /^options/) {
                    if (options[i] == options[i+1]) {
                        if (content[i] ~ /^(option|description)/) {
                            sub(/^[^ ]+ /, " ", content[i]);
                            help = help sprintf("%-10s", content[i]);
                        }
                    } else {
                        help = help "\n";
                    }
                }
            }
            printf help;
        }
        '

cat <<HELP

Version:  2.1.7
Author:   b4b4r07
github:   https://github.com/b4b4r07/enhancd
HELP
