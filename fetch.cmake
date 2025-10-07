include(FetchContent)
cmake_policy(SET CMP0135 NEW)

# Google Tests
FetchContent_Declare(
    googletest
    DOWNLOAD_EXTRACT_TIMESTAMP "true"
    URL https://github.com/google/googletest/releases/download/v1.17.0/googletest-1.17.0.tar.gz
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()
include(GoogleTest)

# processor_api
FetchContent_Declare(
    processor_api
    URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/processor_api-v2.1.0_70.zip
    SOURCE_DIR ${FETCH_LOCATION}/include/processor_api
    FIND_PACKAGE_ARGS MODULE
)
FetchContent_MakeAvailable(processor_api)

# processor_utilities
FetchContent_Declare(
    processor_utilities
    URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/processor_utilities-v1.0.1_13.zip
    SOURCE_DIR ${FETCH_LOCATION}/include/processor_utilities
    FIND_PACKAGE_ARGS MODULE
)
FetchContent_MakeAvailable(processor_utilities)

# os_utilities
FetchContent_Declare(
    os_utilities
    URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/os_utilities-v0.4.0_28.zip
    SOURCE_DIR ${FETCH_LOCATION}/include/os_utilities
    FIND_PACKAGE_ARGS MODULE
)
FetchContent_MakeAvailable(os_utilities)

# gpu_primitives
FetchContent_Declare(
    gpu_primitives
    URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/gpu_primitives-v0.0.2_7.zip
    SOURCE_DIR ${FETCH_LOCATION}/include/gpu_primitives
    FIND_PACKAGE_ARGS MODULE
)
FetchContent_MakeAvailable(gpu_primitives)

# engine_api
FetchContent_Declare(
    engine_api
    URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/engine_api-v2.2.0_63.zip
    SOURCE_DIR ${FETCH_LOCATION}/include/engine_api
    FIND_PACKAGE_ARGS MODULE
)
FetchContent_MakeAvailable(engine_api)

# gpu_audio_client
FetchContent_Declare(
    gpu_audio_client
    URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/gpu_audio_client-v0.1.1_14.zip
    SOURCE_DIR ${FETCH_LOCATION}/include/gpu_audio_client
    FIND_PACKAGE_ARGS MODULE
)
FetchContent_MakeAvailable(gpu_audio_client)

# metal-cpp
if(APPLE)
    FetchContent_Declare(
        metal-cpp
        URL ${METAL_CPP_URL}
        SOURCE_DIR ${FETCH_LOCATION}/include/metal-cpp
        FIND_PACKAGE_ARGS MODULE
    )
    FetchContent_MakeAvailable(metal-cpp)
endif()

# cmake-common
FetchContent_Declare(
    cmake-common
    URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/bg-conan-common-v2.0.3_155.zip
    SOURCE_DIR ${FETCH_LOCATION}/cmake-common
    EXCLUDE_FROM_ALL
)
FetchContent_MakeAvailable(cmake-common)

# custom_binary
if(WITH_HIP)
    FetchContent_Declare(
        custom_binary
        URL https://github.com/gpuaudio/platform_headers/releases/download/v0.0.1/custom_binary-v1.0.0_1.zip
        SOURCE_DIR ${CMAKE_BINARY_DIR}/custom_binary
        EXCLUDE_FROM_ALL
    )
    FetchContent_MakeAvailable(custom_binary)
endif()

# AudioFile
set(WITH_AUDIOFILE TRUE CACHE BOOL "Build with AudioFile dependency")
if(WITH_AUDIOFILE)
    FetchContent_Declare(
        AudioFile
        URL https://github.com/adamstark/AudioFile/archive/refs/tags/1.1.0.zip
        SOURCE_DIR ${FETCH_LOCATION}/include/AudioFile
        FIND_PACKAGE_ARGS MODULE
    )
    set(BUILD_TESTS OFF CACHE BOOL "Switch off AudioFile Tests build")
    set(BUILD_EXAMPLES OFF CACHE BOOL "Switch off AudioFile Examples build")
    FetchContent_MakeAvailable(AudioFile)
endif()