if(NOT TARGET processor_api::processor_api)
    set(PROCESSOR_API_INCLUDE_DIR "${FETCH_LOCATION}/include")
    add_library(processor_api::processor_api INTERFACE IMPORTED)
    set_target_properties(processor_api::processor_api PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${PROCESSOR_API_INCLUDE_DIR}"
    )
    message(STATUS "Component target declared: processor_api::processor_api")
endif()
