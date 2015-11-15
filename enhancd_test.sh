#!/bin/bash

# definition
fzf() { :; }

true=0
false=1

. "${0%/*}"/enhancd.t || exit 1

test_text="$(cat <<EOF
aaa
bbb
aaa
ccc
EOF
)"

describe "enhancd"
  describe "normal function"

    it "unique"
      expect="$(cat <<EOF
aaa
bbb
ccc
EOF
      )"
      actual="$(echo "$test_text" | unique)"
      assert equal "$expect" "$actual"
    end

    it "reverse"
      expect="$(cat <<EOF
ccc
aaa
bbb
aaa
EOF
      )"
      actual="$(echo "$test_text" | reverse)"
      assert equal "$expect" "$actual"
    end

    it "available"
      assert equal $(available notfunc:fzf:peco) fzf
    end

    it "empty"
      empty ""
      assert equal $? $true
    end

    it "has"
      has "ls"
      assert equal $? $true
    end

    it "nl 1"
      expect="$(cat <<EOF
1: aaa
2: bbb
3: aaa
4: ccc
EOF
      )"
      actual="$(echo "$test_text" | nl)"
      assert equal "$expect" "$actual"
    end

    it "nl 2"
      expect="$(cat <<EOF
1-aaa
2-bbb
3-aaa
4-ccc
EOF
      )"
      actual="$(echo "$test_text" | nl "-")"
      assert equal "$expect" "$actual"
    end
  end



  describe "cd function"
    it "cd_get_dirstep"
      expect="$(cat <<EOF
/home/lisa/work/dir/someA
/home/lisa/work/dir
/home/lisa/work
/home/lisa
/home
/
EOF
      )"
      actual="$(cd_get_dirstep /home/lisa/work/dir/someA)"
      assert equal "$expect" "$actual"
    end

    it "cd_split_path"
      expect="$(cat <<EOF
/
home
lisa
work
dir
EOF
      )"
      actual="$(cd_split_path /home/lisa/work/dir/someA)"
      assert equal "$expect" "$actual"
    end

    it "cd_get_dirname"
      expect="$(cat <<EOF
/
home
lisa
work
dir
EOF
      )"
      actual="$(cd_get_dirname /home/lisa/work/dir/someA)"
      assert equal "$expect" "$actual"
    end

    it "cd_get_abspath"
#devided_path="$(
#/
#home
#lisa
#work
#dir
#)"
##expect="$(cat <<EOF
##/home/lisa/work
##EOF
##)"
#expect="/home/lisa/work"
#actual="$(cd_get_abspath work "$devided_path")"
#      assert equal "$expect" "$actual"
    end

    it "cd_fuzzy"
      text="$(cat <<EOF
/home/lisa/work/dir/test
/home/lisa/work/dir/abcd
/home/lisa/work/dir/efgh
EOF
      )"
      expect="/home/lisa/work/dir/test"
      actual="$(echo "$text" | cd_fuzzy post)"
      assert equal "$expect" "$actual"
    end

    it "cd_narrow"
      text="$(cat <<EOF
/home/lisa/work/dir/test
/home/lisa/work/dir/abcd
/home/lisa/work/dir/efgh
EOF
      )"
      expect="/home/lisa/work/dir/abcd"
      actual="$(echo "$text" | cd_narrow a)"
      assert equal "$expect" "$actual"
    end

    it "cd_enumrate"
      expect="$(cat <<EOF
/
/home
/home/lisa
/home/lisa/src
/home/lisa/src/github.com
EOF
      )"
      actual="$(cd_enumrate /home/lisa/src/github.com)"
      assert equal "$expect" "$actual"
    end

  end
end
