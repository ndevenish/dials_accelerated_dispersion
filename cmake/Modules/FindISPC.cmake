

# Look for ISPC
if (NOT ISPC_EXECUTABLE)
    find_program(ISPC_EXECUTABLE ispc DOC "ispc executable location")
    if (NOT ISPC_EXECUTABLE)
        # message(SEND_ERROR "ispc compiler not found")
    else()
        # message(STATUS "Found ispc: ${ISPC}")
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ISPC DEFAULT_MSG ISPC_EXECUTABLE)
