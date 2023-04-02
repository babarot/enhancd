Output options.gif

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
Type "alias vim='nvim -u NONE'" Enter
Type "cd ~" Enter
Ctrl+L
Show

Set PlaybackSpeed 0.2

Sleep 1s
Type "cd --help" Sleep 1s Enter
Sleep 1s

Sleep 1s
Type "# You can add new option as you like by editing config file!" Sleep 1s Ctrl+C
Enter Enter
Type "vim ~/.config/enhancd/config.ltsv" Sleep 1s Enter
Type "i"
Type `short:-G	long:--ghq	desc:Show ghq list	func:ghq list --full-path	condition:which ghq` Sleep 1s
Escape
Type@300ms ":wq" Sleep 1s Enter

Sleep 1s
Enter Enter
Type "cd --help" Sleep 1s Enter
Sleep 1s

Type "# ghq option has been added! Let's try it out" Sleep 1s Ctrl+C
Enter Enter
Sleep 1s
Type "cd --ghq" Sleep 1s Enter
Sleep 1s
Type "enhancd" Sleep 1s Enter

# end
Enter Enter Enter
Sleep 500ms
Type "END."
Sleep 2
