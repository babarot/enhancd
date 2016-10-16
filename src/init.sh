# make a log file and a root directory
mkdir -p "$ENHANCD_DIR"
touch "$ENHANCD_DIR/enhancd.log"

# alias to cd
eval "alias ${ENHANCD_COMMAND:=cd}=__enhancd::cd"
if [[ $ENHANCD_COMMAND != "cd" ]]; then
    unalias cd &>/dev/null
fi

# Set the filter if empty
if [[ -z $ENHANCD_FILTER ]]; then
    ENHANCD_FILTER="fzf-tmux:fzf:peco:fzy:percol:gof:pick:icepick:sentaku:selecta"
fi
_ENHANCD_FILTER="$(__enhancd::utils::available "$ENHANCD_FILTER")"

# In zsh it will cause field splitting to be performed
# on unquoted parameter expansions.
if __enhancd::utils::has "setopt" && [[ -n $ZSH_VERSION ]]; then
    # Note in particular the fact that words of unquoted parameters are not
    # automatically split on whitespace unless the option SH_WORD_SPLIT is set;
    # see references to this option below for more details.
    # This is an important difference from other shells.
    # (Zsh Manual 14.3 Parameter Expansion)
    setopt localoptions SH_WORD_SPLIT
fi

for f in "$ENHANCD_ROOT"/custom/sources/*.sh
do
    source "$f"
done

unset f line
