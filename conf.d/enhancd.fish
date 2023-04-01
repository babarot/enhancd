function __enhancd_install --on-event enhancd_install
    set -l root (string join / (status filename | string split /)[1..-3])

    set -Ux ENHANCD_ROOT "$root/functions/enhancd"
    set -Ux ENHANCD_DIR "$HOME/.enhancd"
    set -Ux ENHANCD_COMMAND "cd"

    set -Ux ENHANCD_ENABLE_DOUBLE_DOT true
    set -Ux ENHANCD_ENABLE_SINGLE_DOT true
    set -Ux ENHANCD_ENABLE_HYPHEN true
    set -Ux ENHANCD_ENABLE_HOME true

    set -Ux ENHANCD_ARG_DOUBLE_DOT ".."
    set -Ux ENHANCD_ARG_SINGLE_DOT "."
    set -Ux ENHANCD_ARG_HYPHEN "-"
    set -Ux ENHANCD_ARG_HOME ""
    set -Ux ENHANCD_HYPHEN_NUM 10
    set -Ux ENHANCD_USE_ABBREV false

    set -Ux ENHANCD_COMPLETION_DEFAULT 1
    set -Ux ENHANCD_COMPLETION_BEHAVIOR "default"

    set -Ux ENHANCD_COMPLETION_KEYBIND "^I"

    set -Ux _ENHANCD_VERSION (command cat "$root/VERSION")

    # Set the filters if empty
    set -Ux ENHANCD_FILTER "fzy:fzf:peco:sk:zf"

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
    set --erase ENHANCD_USE_ABBREV
    set --erase ENHANCD_COMMAND
    set --erase ENHANCD_ROOT
    set --erase ENHANCD_DIR
    set --erase ENHANCD_ENABLE_DOUBLE_DOT
    set --erase ENHANCD_ENABLE_SINGLE_DOT
    set --erase ENHANCD_ENABLE_HYPHEN
    set --erase ENHANCD_ENABLE_HOME
    set --erase ENHANCD_ARG_DOUBLE_DOT
    set --erase ENHANCD_ARG_SINGLE_DOT
    set --erase ENHANCD_ARG_HYPHEN
    set --erase ENHANCD_HYPHEN_NUM
    set --erase ENHANCD_ARG_HOME
    set --erase ENHANCD_COMPLETION_DEFAULT
    set --erase ENHANCD_COMPLETION_BEHAVIOR
    set --erase ENHANCD_COMPLETION_KEYBIND
    set --erase ENHANCD_FILTER
    set --erase _ENHANCD_VERSION
end

# alias to enhancd
if test -n "$ENHANCD_COMMAND"
    _enhancd_alias
end

# bindings
bind \ef '_enhancd_complete'
