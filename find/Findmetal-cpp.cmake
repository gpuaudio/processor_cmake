if(NOT TARGET metal-cpp::metal-cpp)
    add_library(metal-cpp::metal-cpp INTERFACE IMPORTED)

    set_target_properties(metal-cpp::metal-cpp PROPERTIES
        INTERFACE_COMPILE_FEATURES "cxx_std_17"
        INTERFACE_INCLUDE_DIRECTORIES "${FETCH_LOCATION}/include/metal-cpp"
        INTERFACE_LINK_LIBRARIES "-framework Foundation;-framework Quartz;-framework Metal"
    )
    message(STATUS "Component target declared: metal-cpp::metal-cpp")
endif()
