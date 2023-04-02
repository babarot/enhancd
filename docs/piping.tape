Output piping.gif

Set Theme "TokyoNight"
Set Theme "TokyoNightLight"

Set FontSize 40
Set Width 1800
Set Height 800

Set Shell zsh

Hide
Type `export PROMPT="%F{blue}%c%f %# "` Enter
Type "source $PWD/init.sh" Enter
Type "export ENHANCD_FILTER=fzy:fzf:peco:zf:sk" Enter
Type "export ENHANCD_DIR=$PWD/docs" Enter
Type "cd ~" Enter
Ctrl+L
Show

Set PlaybackSpeed 0.2

# First
Sleep 1s
Type "# You can pipe one or multiple directory paths to cd" Sleep 1s Ctrl+C
Type "ghq list --full-path | cd" Sleep 1s Enter
Sleep 1s
Down@200ms 3 Sleep 1s
Up@200ms 2 Sleep 1s
Type "dot" Sleep 1s Enter

# Second
Enter Enter
Sleep 1s
Type "echo ~/src/github.com/b4b4r07/enhancd | cd" Sleep 1s Enter
Sleep 1s

# end
Enter Enter Enter
Sleep 500ms
Type "END."
Sleep 2
