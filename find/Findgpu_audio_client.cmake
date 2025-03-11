if(NOT TARGET gpu_audio_client::gpu_audio_client)
    set(gpu_audio_client_INCLUDE_DIR "${FETCH_LOCATION}/include")
    add_library(gpu_audio_client::gpu_audio_client INTERFACE IMPORTED)
    set_target_properties(gpu_audio_client::gpu_audio_client PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${gpu_audio_client_INCLUDE_DIR}"
    )
    message(STATUS "Component target declared: gpu_audio_client::gpu_audio_client")
endif()
