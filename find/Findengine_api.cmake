if(NOT TARGET engine_api::engine_api)
    set(engine_api_INCLUDE_DIR "${FETCH_LOCATION}/include")
    add_library(engine_api::engine_api INTERFACE IMPORTED)
    set_target_properties(engine_api::engine_api PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${engine_api_INCLUDE_DIR}"
    )
    message(STATUS "Component target declared: engine_api::engine_api")
endif()
