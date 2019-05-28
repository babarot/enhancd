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

T_SUB "unique" ((
  p1a="$(echo -e "aaa${LF}bbb${LF}ccc")"
  p1b="$(echo "$dummy" | __enhancd::filter::unique)"
  t_ok $? "unique 1"
  t_is "$p1a" "$p1b" "unique 2"
))
T_SUB "reverse" ((
  p1a="$(echo -e "bbb${LF}aaa${LF}ccc${LF}bbb${LF}aaa")"
  p1b="$(echo "$dummy" | __enhancd::filter::reverse)"
  t_ok $? "reverse 1"
  t_is "$p1a" "$p1b" "reverse 2"
))
T_SUB "available" ((
  p1a="filter"
  p1b="$(__enhancd::core::get_filter_command 'my_filter1:my_filter2:filter:my_filter3')"
  t_ok $? "available 1"
  t_is "$p1a" "$p1b" "available 2"
))
T_SUB "has" ((
  __enhancd::command::which "ls"
  t_ok $? "has 1"
))
T_SUB "nl" ((
  p1a="$(echo -e "1: aaa${LF}2: bbb${LF}3: ccc${LF}4: aaa${LF}5: bbb")"
  p1b="$(echo "$dummy" | __enhancd::command::nl)"
  t_ok $? "nl 1"
  t_is "$p1a" "$p1b" "nl 2"
  p1a="$(echo -e "1. aaa${LF}2. bbb${LF}3. ccc${LF}4. aaa${LF}5. bbb")"
  p1b="$(echo "$dummy" | __enhancd::command::nl '. ')"
  t_ok $? "nl 3"
  t_is "$p1a" "$p1b" "nl 4"
))
