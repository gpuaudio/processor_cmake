if(NOT TARGET gpu_primitives::gpu_primitives)
    set(GPU_PRIMITIVES_INCLUDE_DIR "${FETCH_LOCATION}/include/gpu_primitives/include")
    add_library(gpu_primitives::gpu_primitives INTERFACE IMPORTED)
    set_target_properties(gpu_primitives::gpu_primitives PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${GPU_PRIMITIVES_INCLUDE_DIR}"
    )
message(STATUS "Component target declared: gpu_primitives::gpu_primitives")
endif()
