function __enhancd_install --on-event enhancd_install
    set -l root (string join / (status filename | string split /)[1..-3])
    
    set -Ux ENHANCD_FILTER
    set -Ux ENHANCD_COMMAND "cd"

    set -Ux ENHANCD_ROOT "$root/functions/enhancd"

    set -Ux ENHANCD_DIR "$HOME/.enhancd"
    set -Ux ENHANCD_DISABLE_DOT 0
    set -Ux ENHANCD_DISABLE_HYPHEN 0
    set -Ux ENHANCD_DISABLE_HOME 0

    set -Ux ENHANCD_DOT_ARG ".."
    set -Ux ENHANCD_HYPHEN_ARG "-"
    set -Ux ENHANCD_HYPHEN_NUM 10
    set -Ux ENHANCD_HOME_ARG ""
    set -Ux ENHANCD_USE_FUZZY_MATCH 1

    set -Ux ENHANCD_COMPLETION_DEFAULT 1
    set -Ux ENHANCD_COMPLETION_BEHAVIOR "default"

    set -Ux ENHANCD_COMPLETION_KEYBIND "^I"

    set -Ux _ENHANCD_VERSION "2.2.4"
    set -Ux _ENHANCD_SUCCESS 0
    set -Ux _ENHANCD_FAILURE 60

    # Set the filters if empty
    set -Ux ENHANCD_FILTER "fzy:fzf-tmux:fzf:peco:percol:gof:pick:icepick:sentaku:selecta"

    # make a log file and a root directory
    if not test -d "$ENHANCD_DIR"
        mkdir -p "$ENHANCD_DIR"
    end

    if not test -f "$ENHANCD_DIR/enhancd.log"
        touch "$ENHANCD_DIR/enhancd.log"
    end

    _enhancd_alias
end

function __enhancd_uninstall --on-event enhancd_uninstall
    command rm -rf $ENHANCD_DIR
    set --erase ENHANCD_FILTER
    set --erase ENHANCD_COMMAND
    set --erase ENHANCD_ROOT
    set --erase ENHANCD_DIR
    set --erase ENHANCD_DISABLE_DOT
    set --erase ENHANCD_DISABLE_HYPHEN
    set --erase ENHANCD_DISABLE_HOME
    set --erase ENHANCD_DOT_ARG
    set --erase ENHANCD_HYPHEN_ARG
    set --erase ENHANCD_HYPHEN_NUM
    set --erase ENHANCD_HOME_ARG
    set --erase ENHANCD_USE_FUZZY_MATCH
    set --erase ENHANCD_COMPLETION_DEFAULT
    set --erase ENHANCD_COMPLETION_BEHAVIOR
    set --erase ENHANCD_COMPLETION_KEYBIND
    set --erase ENHANCD_FILTER
    set --erase _ENHANCD_VERSION
    set --erase _ENHANCD_SUCCESS
    set --erase _ENHANCD_FAILURE
end

# alias to enhancd
if test -n "$ENHANCD_COMMAND"
    _enhancd_alias
end

# bindings
bind \ef '_enhancd_complete'
