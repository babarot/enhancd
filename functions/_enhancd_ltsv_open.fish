function _enhancd_ltsv_open
    set -l configs
    set -a configs "$ENHANCD_ROOT/options.ltsv"
    set -a configs "$ENHANCD_DIR/options.ltsv"
    set -a configs "$HOME/.config/enhancd/options.ltsv"

    for config in "$configs"
        if test -f "$config"
            command cat "$config"
        end
    end
end
