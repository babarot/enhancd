function _enhancd_ltsv_open
    set -l configs
    set -a configs "$ENHANCD_ROOT/config.ltsv"
    set -a configs "$ENHANCD_DIR/config.ltsv"
    set -a configs "$HOME/.config/enhancd/config.ltsv"

    for config in "$configs"
        if test -f "$config"
            command cat "$config"
        end
    end
end
