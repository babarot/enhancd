Output demo.gif

# Set Theme "Builtin Solarized Dark"

Set FontSize 30
Set Width 1200
Set Height 600

Set Shell bash

Hide
Type "source init.sh" Enter
#
Type "export PS1='\[\e[38;2;90;86;224m\]\W\[\e[0m\] \$ '" Enter
Type "export ENHANCD_FILTER=fzy:fzf:peco:zf:sk" Enter
Type "cd ~" Enter
Ctrl+L
Show

Set PlaybackSpeed 0.5

# First
Sleep 1
Type "cd" Sleep 1 Enter
Down 5 Sleep 1
Up 3 Sleep 1
Type@250ms "afx" Sleep 1 Enter

# Second
Sleep 1
Type "echo $ENHANCD_FILTER" Sleep 1 Enter
Type "export ENHANCD_FILTER=fzf:$ENHANCD_FILTER" Sleep 1 Enter
Type "cd" Sleep 1 Enter
Sleep 1
Type "cd$" Sleep 1 Enter
Enter

# Third
Type "export ENHANCD_FILTER='fzf --preview=ls --preview-window=down,50%'" Sleep 1 Enter
Sleep 1
Type "cd .." Sleep 1 Enter
Down 3 Sleep 1
Up 2 Sleep 1
Enter

# Third
Sleep 1
Type "cd afx" Sleep 1 Enter
Sleep 1
Enter

Type "pwd" Sleep 1 Enter

# Forth
Sleep 1
Type "you can typo" Sleep 1 Ctrl+C
Type "cd enhandc # typo" Sleep 1 Enter
Sleep 1
Enter

Type "pwd" Sleep 1 Enter

# end
Sleep 2
