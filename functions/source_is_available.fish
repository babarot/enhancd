function source_is_available
    filepath_split_list "$ENHANCD_FILTER" 2 >/dev/null
    and [ -s $ENHANCD_DIR/enhancd.log ]
    return $status
end
