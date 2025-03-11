if(NOT TARGET os_utilities::os_utilities)
    set(OS_UTILITIES_INCLUDE_DIR "${FETCH_LOCATION}/include/os_utilities")
    add_library(os_utilities::os_utilities INTERFACE IMPORTED)
    set_target_properties(os_utilities::os_utilities PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${OS_UTILITIES_INCLUDE_DIR}"
    )
message(STATUS "Component target declared: os_utilities::os_utilities")
endif()
