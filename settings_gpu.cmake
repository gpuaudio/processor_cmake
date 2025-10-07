message(STATUS "Using Settings from: ${CMAKE_CURRENT_LIST_FILE}")

set(CONAN_CUDA_ARCH "52;60;61;70;75;80;86;87;89;90;120")

set(CONAN_HIP_ARCH "gfx1030;gfx1031;gfx1032;gfx1100;gfx1101;gfx1102;gfx1151;gfx1200;gfx1201")

# Preprocessor definitions
string(REGEX REPLACE "[;]" ":" cuda_archs "${CONAN_CUDA_ARCH}")
string(REGEX REPLACE "[;]" ":" hip_archs "${CONAN_HIP_ARCH}")

add_definitions(-DCUDA_ARCHS="${cuda_archs}")
add_definitions(-DHIP_ARCHS="${hip_archs}")

MESSAGE(STATUS "CUDA_ARCHS: ${cuda_archs}")
MESSAGE(STATUS "HIP_ARCHS: ${hip_archs}")
