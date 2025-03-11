if(NOT TARGET AudioFile::AudioFile)
    set(AUDIO_FILE_INCLUDE_DIR "${FETCH_LOCATION}/include/AudioFile")
    add_library(AudioFile::AudioFile INTERFACE IMPORTED)
    set_target_properties(AudioFile::AudioFile PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${AUDIO_FILE_INCLUDE_DIR}"
    )
    message(STATUS "Component target declared: AudioFile::AudioFile")
endif()
