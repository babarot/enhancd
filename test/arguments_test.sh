#!/bin/bash

filter() { :; }

LF=$(printf '\\\012_')
LF=${LF%_}
true=0
false=1
dummy="aaa
bbb
ccc
aaa
bbb"

# Load enhancd
. "$ENHANCD_ROOT/init.sh" || exit 1

T_SUB "option" ((
  actual="$(__enhancd::arguments::option -h 2>&1)"
  t_ok $? "die 1"
  t_is "-h: no such option" "$actual"
))

T_SUB "hyphen" ((
))

T_SUB "dot" ((
))

T_SUB "none" ((
))

T_SUB "given" ((
))
