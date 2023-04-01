Output demo.gif

#Set Theme "Builtin Solarized Dark"
#Set Theme "TokyoNightLight"
#Set Theme "nord"
#Set Theme "Tinacious Design (Light)"
#Set Theme "Violet Light"
#Set Theme "Tomorrow"

# Dark theme
#Set Theme { "name": "Whimsy", "black": "#535178", "red": "#ef6487", "green": "#5eca89", "yellow": "#fdd877", "blue": "#65aef7", "magenta": "#aa7ff0", "cyan": "#43c1be", "white": "#ffffff", "brightBlack": "#535178", "brightRed": "#ef6487", "brightGreen": "#5eca89", "brightYellow": "#fdd877", "brightBlue": "#65aef7", "brightMagenta": "#aa7ff0", "brightCyan": "#43c1be", "brightWhite": "#ffffff", "background": "#29283b", "foreground": "#b3b0d6", "selection": "#3d3c58", "cursor": "#b3b0d6" }

# Light theme
Set Theme { "name": "Spring", "black": "#000000", "red": "#ff4d83", "green": "#1f8c3b", "yellow": "#1fc95b", "blue": "#1dd3ee", "magenta": "#8959a8", "cyan": "#3e999f", "white": "#ffffff", "brightBlack": "#000000", "brightRed": "#ff0021", "brightGreen": "#1fc231", "brightYellow": "#d5b807", "brightBlue": "#15a9fd", "brightMagenta": "#8959a8", "brightCyan": "#3e999f", "brightWhite": "#ffffff", "background": "#ffffff", "foreground": "#4d4d4c", "cursor": "#f8aba6" }

Set FontSize 40
Set Width 1800
Set Height 1000

Set Shell bash

Hide
Type "source $PWD/init.sh" Enter
#
Type `export FZF_DEFAULT_OPTS='--height 75% --reverse --margin=0,1 --bind ctrl-p:toggle-preview,ctrl-f:page-down,ctrl-b:page-up --bind pgdn:preview-page-down,pgup:preview-page-up --pointer="▶" --prompt="❯ " --no-separator --scrollbar="█" --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479 --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692 --color prompt:#87afff,pointer:#ff5189,marker:#f09479'` Enter
Type "export PS1='\[\e[38;2;90;86;224m\]\W\[\e[0m\] \$ '" Enter
Type "export ENHANCD_FILTER=fzy:fzf:peco:zf:sk" Enter
Type "export ENHANCD_DIR=$PWD/docs" Enter
Type "cd ~" Enter
Ctrl+L
Show

Set PlaybackSpeed 0.2

# First
Sleep 1s
Type "cd" Sleep 1s Enter
Sleep 1s
Down@100ms 5
Up@100ms 3
Sleep 1s
Type@200ms "afx" Sleep 1s Enter

# Second
Sleep 1s
Type@30ms "echo $ENHANCD_FILTER" Sleep 1s Enter Sleep 1
Type "# Let's raise the priority of using fzf" Sleep 1s Ctrl+C
Type@30ms "export ENHANCD_FILTER=fzf:$ENHANCD_FILTER" Sleep 1s Enter
Type "cd" Sleep 1s Enter
Sleep 1s
Type@200ms "cd$" Sleep 1s Enter
Enter

# Third
Type "# Let's configure fzf previewer as enhancd filter" Sleep 1s Ctrl+C
Type@20ms `export ENHANCD_FILTER="fzf --preview='exa --tree --group-directories-first --git-ignore --level 1 {}'"` Sleep 1s Enter
Sleep 1s
Type "cd .." Sleep 1s Enter
Sleep 1s
Down@200ms 3 Sleep 1s
Up@200ms 2 Sleep 1s
Enter

# Third
Sleep 1s
Type "cd afx" Sleep 1s Enter
Sleep 500ms
Ctrl+P # toggle preview
Sleep 500ms
Sleep 500ms Down 1
Sleep 500ms Up 1
Sleep 1s
Enter

Type "pwd" Sleep 1s Enter

# Forth
Sleep 1s
Type "cd enhandc  # works fine even if typo!" Sleep 1s Enter
Sleep 1s

# Last
Sleep 1s
Type "cd .  # finds sub dirs!" Sleep 1s Enter
Sleep 1s
Type@200ms "src" Sleep 1s Enter
Sleep 1s

# end
Enter Enter Enter
Sleep 500ms
Type "END."
Sleep 2
