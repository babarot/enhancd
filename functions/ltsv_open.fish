function ltsv_open
    set -l configs
    set -a configs "$ENHANCD_ROOT/config.ltsv"
    set -a configs "$ENHANCD_DIR/config.ltsv"

    set -l config
    for config in "$configs"
        if [ -f "$config" ]
            cat "$config"
        end
    end
end
