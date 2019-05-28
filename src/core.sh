# Returns true if enhancd is ready to be available
__enhancd::core::is_available()
{
    __enhancd::filepath::split_list "${ENHANCD_FILTER}" \
        &>/dev/null && [[ -s ${ENHANCD_DIR}/enhancd.log ]]
    return ${?}
}
