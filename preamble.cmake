#
# Common configuration
#

include_guard()

list(APPEND CMAKE_PROJECT_TOP_LEVEL_INCLUDES
    "${CMAKE_CURRENT_SOURCE_DIR}/dep_provider.cmake")

set(CMAKE_CONFIGURATION_TYPES "Debug;RelWithDebInfo;Release")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/find)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(APPLE)
    message(STATUS "CMake generator: ${CMAKE_GENERATOR}")
    if(NOT CMAKE_GENERATOR MATCHES "^Xcode$")
        message(FATAL_ERROR "Set CMake generator to Xcode by passing \`-GXcode\` command-line switch")
    endif()

    # xcode-select -p
    # ls /Library/Developer/CommandLineTools/SDKs/
    # Checklist for changed OSX_SYSROOT:
    # - check URL in FetchContent_Declare(metal-cpp)
    # - check BG_METAL_VERSION cmake variable

    # set(CMAKE_OSX_SYSROOT /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.sdk)
    # set(CMAKE_OSX_SYSROOT /Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk)
    # set(CMAKE_OSX_DEPLOYMENT_TARGET "15.0" CACHE STRING "Minimum deployment target")

    string(APPEND CMAKE_CXX_FLAGS " -stdlib=libc++")
    set(CMAKE_OSX_ARCHITECTURES arm64)
endif()

if(WIN32)
#    set(CUDA_VERSION "11.8" CACHE STRING "CUDA Toolkit version")

    if(NOT DEFINED CUDA_VERSION AND DEFINED ENV{CUDA_PATH})
        message(STATUS "CUDA Toolkit version: from VS Toolset (MSVC)")
    endif()
    if(DEFINED CUDA_VERSION)
        message(STATUS "CUDA Toolkit version: ${CUDA_VERSION}")
    endif()

    if(DEFINED CUDA_VERSION AND(CUDA_VERSION VERSION_LESS 12.4))
        set(VS_TOOLSET_VERSION "14.34.31933")
    endif()
    if(DEFINED CUDA_VERSION AND NOT(CUDA_VERSION VERSION_LESS 12.4))
        set(VS_TOOLSET_VERSION "14.42.34433")
    endif()

    # CMAKE_GENERATOR_TOOLSET
    set(CMAKE_GENERATOR_PLATFORM "x64")
    set(WINDOWS_TARGET_ARCH x64)

    set(CMAKE_GENERATOR_TOOLSET "v143,host=x64")
    if(DEFINED VS_TOOLSET_VERSION)
        set(CMAKE_GENERATOR_TOOLSET "${CMAKE_GENERATOR_TOOLSET},version=${VS_TOOLSET_VERSION}")
    endif()
    if(DEFINED CUDA_VERSION)
        set(CMAKE_GENERATOR_TOOLSET "${CMAKE_GENERATOR_TOOLSET},cuda=${CUDA_VERSION}")
    endif()

#    set(CMAKE_GENERATOR_TOOLSET "v143,host=x64,version=14.34.31933,cuda=12.0")
#    set(CMAKE_GENERATOR_TOOLSET "v143,host=x64,version=14.42.34433,cuda=12.6")
    message(STATUS "CMAKE_GENERATOR_TOOLSET: ${CMAKE_GENERATOR_TOOLSET}")
endif()
