Output inputs.gif

# Dark theme
#Set Theme { "name": "Whimsy", "black": "#535178", "red": "#ef6487", "green": "#5eca89", "yellow": "#fdd877", "blue": "#65aef7", "magenta": "#aa7ff0", "cyan": "#43c1be", "white": "#ffffff", "brightBlack": "#535178", "brightRed": "#ef6487", "brightGreen": "#5eca89", "brightYellow": "#fdd877", "brightBlue": "#65aef7", "brightMagenta": "#aa7ff0", "brightCyan": "#43c1be", "brightWhite": "#ffffff", "background": "#29283b", "foreground": "#b3b0d6", "selection": "#3d3c58", "cursor": "#b3b0d6" }

# Light theme
#Set Theme { "name": "Spring", "black": "#000000", "red": "#ff4d83", "green": "#1f8c3b", "yellow": "#1fc95b", "blue": "#1dd3ee", "magenta": "#8959a8", "cyan": "#3e999f", "white": "#ffffff", "brightBlack": "#000000", "brightRed": "#ff0021", "brightGreen": "#1fc231", "brightYellow": "#d5b807", "brightBlue": "#15a9fd", "brightMagenta": "#8959a8", "brightCyan": "#3e999f", "brightWhite": "#ffffff", "background": "#ffffff", "foreground": "#4d4d4c", "cursor": "#f8aba6" }

Set Theme "TokyoNight"

Set FontSize 45
Set Width 1800
Set Height 1000

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
Sleep 1s
Type "echo ~/src/github.com/b4b4r07/enhancd | cd" Sleep 1s Enter
Sleep 1s

# end
Enter Enter Enter
Sleep 500ms
Type "END."
Sleep 2
