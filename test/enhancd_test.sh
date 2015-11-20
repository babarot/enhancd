#!/bin/bash

# definition
fzf() { :; }

true=0
false=1

. ./enhancd.sh || exit 1

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
      expect="aaa\nbbb\nccc"
      actual="$(echo "$test_text" | unique)"
      assert equal "$expect" "$actual"
    end

    it "reverse"
      expect="ccc\naaa\nbbb\naaa"
      actual="$(echo "$test_text" | reverse)"
      assert equal "$expect" "$actual"
    end

    it "available"
      assert equal "$(available "notfunc:fzf:peco")" "fzf"
    end

    it "available (space)"
      assert equal "$(available "notfunc:fzf --select-1:peco")" "fzf --select-1"
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
      expect="1: aaa\n2: bbb\n3: aaa\n4: ccc"
      actual="$(echo "$test_text" | nl)"
      assert equal "$expect" "$actual"
    end

    it "nl 2"
      expect="1-aaa\n2-bbb\n3-aaa\n4-ccc"
      actual="$(echo "$test_text" | nl "-")"
      assert equal "$expect" "$actual"
    end
  end

  describe "cd function"
    it "cd::get_dirstep"
      expect="$(cat <<EOF
/home/lisa/work/dir/someA
/home/lisa/work/dir
/home/lisa/work
/home/lisa
/home
/
EOF
)"
      actual="$(cd::get_dirstep /home/lisa/work/dir/someA)"
      assert equal "$expect" "$actual"
    end

    it "cd::split_path"
      expect="$(cat <<EOF
/
home
lisa
work
dir
EOF
)"
      actual="$(cd::split_path /home/lisa/work/dir/someA)"
      assert equal "$expect" "$actual"
    end

    it "cd::get_dirname"
      expect="$(cat <<EOF
/
home
lisa
work
dir
EOF
)"
      actual="$(cd::get_dirname /home/lisa/work/dir/someA)"
      assert equal "$expect" "$actual"
    end

    it "cd::get_abspath"
    end

    it "cd::list"
      expect="$(cat <<EOF
ccc
aaa
bbb
)"
      actual="$(echo "$test_text" | cd::list)"
      assert equal "$expect" "$actual"
    end

    it "cd::fuzzy"
      text="$(cat <<EOF
/home/lisa/work/dir/test
/home/lisa/work/dir/abcd
/home/lisa/work/dir/efgh
EOF
)"
      expect="/home/lisa/work/dir/test"
      actual="$(echo "$text" | cd::fuzzy post)"
      assert equal "$expect" "$actual"
    end

    it "cd::narrow"
      text="$(cat <<EOF
/home/lisa/work/dir/test
/home/lisa/work/dir/abcd
/home/lisa/work/dir/efgh
EOF
)"
      expect="/home/lisa/work/dir/abcd"
      actual="$(echo "$text" | cd::narrow a)"
      assert equal "$expect" "$actual"
    end

    it "cd::enumrate"
      expect="$(cat <<EOF
/
/home
/home/lisa
/home/lisa/src
/home/lisa/src/github.com
EOF
)"
      actual="$(cd::enumrate /home/lisa/src/github.com)"
      assert equal "$expect" "$actual"
    end

    it "cd::interface"
      # before
      list="$(cat <<EOF
$HOME/enhancd_testA
$HOME/enhancd_testB
EOF
)"
      mkdir -p ~/enhancd_test{A,B}
      fzf() { head -n 1; }
      export ENHANCD_FILTER=fzf

      # test
      expect="$HOME/enhancd_testA"
      actual="$(cd::interface "$list" && pwd)"
      assert equal "$expect" "$actual"

      # after
      rmdir ~/enhancd_test{A,B}
    end

    it "cd::interface .."
      # before
      list="$(cat <<EOF
a
b
c
EOF
)"
      mkdir -p ~/enhancd_test/a/b/c/d/e/f
      builtin cd ~/enhancd_test/a/b/c/d/e/f
      fzf() { head -n 2 | tail -n 1; }
      export ENHANCD_FILTER=fzf

      # test
      expect="$HOME/enhancd_test/a/b"
      actual="$(cd::interface ".." "$list" && pwd)"
      assert equal "$expect" "$actual"

      # after
      rm -r ~/enhancd_test
    end

  end
end
