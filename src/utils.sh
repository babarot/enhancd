#!/bin/bash

__enhancd::utils::available()
{
    __enhancd::core::get_filter_command "$ENHANCD_FILTER" &>/dev/null &&
        [[ -s $ENHANCD_DIR/enhancd.log ]]
}
