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
. ./init.sh || exit 1

T_SUB "die" ((
  p2="$(__enhancd::utils::die "error\n" 2>/dev/null)"
  t_ok $? "die 1"
  t_ok "-z $p2" "die 2"
))
T_SUB "unique" ((
  p1a="$(echo -e "aaa${LF}bbb${LF}ccc")"
  p1b="$(echo "$dummy" | __enhancd::utils::unique)"
  t_ok $? "unique 1"
  t_is "$p1a" "$p1b" "unique 2"
))
T_SUB "reverse" ((
  p1a="$(echo -e "bbb${LF}aaa${LF}ccc${LF}bbb${LF}aaa")"
  p1b="$(echo "$dummy" | __enhancd::utils::reverse)"
  t_ok $? "reverse 1"
  t_is "$p1a" "$p1b" "reverse 2"
))
T_SUB "available" ((
  p1a="filter"
  p1b="$(__enhancd::utils::available 'my_filter1:my_filter2:filter:my_filter3')"
  t_ok $? "available 1"
  t_is "$p1a" "$p1b" "available 2"
))
T_SUB "has" ((
  __enhancd::utils::has "ls"
  t_ok $? "has 1"
))
T_SUB "nl" ((
  p1a="$(echo -e "1: aaa${LF}2: bbb${LF}3: ccc${LF}4: aaa${LF}5: bbb")"
  p1b="$(echo "$dummy" | __enhancd::utils::nl)"
  t_ok $? "nl 1"
  t_is "$p1a" "$p1b" "nl 2"
  p1a="$(echo -e "1. aaa${LF}2. bbb${LF}3. ccc${LF}4. aaa${LF}5. bbb")"
  p1b="$(echo "$dummy" | __enhancd::utils::nl '. ')"
  t_ok $? "nl 3"
  t_is "$p1a" "$p1b" "nl 4"
))
