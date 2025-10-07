cmake_minimum_required(VERSION 3.24.0 FATAL_ERROR)

# Include preamble for common setup
include(${CMAKE_CURRENT_SOURCE_DIR}/preamble.cmake)

# Define the top-level project
project(gpu_processors
        VERSION 1.0.0
        LANGUAGES C CXX
        DESCRIPTION "GPU Audio Processors"
        HOMEPAGE_URL "https://gpu.audio")

# Define the list of processors to build
if(NOT DEFINED PROCESSOR_LIST)
    file(GLOB_RECURSE folders
         LIST_DIRECTORIES YES
         RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/.."
         "../*"
    )
    foreach(folder IN LISTS folders)
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../${folder}/PROCESSOR")
            list(APPEND PROCESSOR_LIST ${folder})
        endif()
    endforeach()
endif()

# Configure build output paths
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Automatically ignore the build directory
file(WRITE ${CMAKE_BINARY_DIR}/.gitignore "*")

# Include settings
include(${CMAKE_CURRENT_SOURCE_DIR}/settings.cmake)

# Set location for fetched dependencies (shared across all processors)
if (NOT DEFINED FETCH_LOCATION)
    set(FETCH_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/../gpuaudio")
endif ()

# Fetch dependencies once at the top level
include(${CMAKE_CURRENT_SOURCE_DIR}/fetch.cmake)

# Automatically git-ignore fetched content
file(WRITE ${FETCH_LOCATION}/.gitignore "*")

# Configure CUDA if enabled
if(NOT APPLE AND WITH_CUDA)
    enable_language(CUDA)
    if(DEFINED CUDA_VERSION)
        find_package(CUDAToolkit ${CUDA_VERSION} REQUIRED EXACT MODULE BYPASS_PROVIDER)
    else()
        find_package(CUDAToolkit REQUIRED MODULE BYPASS_PROVIDER)
        set(CUDA_VERSION "${CUDAToolkit_VERSION_MAJOR}.${CUDAToolkit_VERSION_MINOR}")
        message(STATUS "CUDA Toolkit version: ${CUDA_VERSION}")
    endif()
    if(NOT CUDAToolkit_FOUND)
        message(FATAL_ERROR "CUDA Toolkit not found")
    endif()

    if(CUDA_VERSION VERSION_LESS 12.0)
        set(CMAKE_CUDA_STANDARD "17")
    else()
        set(CMAKE_CUDA_STANDARD "20")
    endif()

    set(CMAKE_CUDA_STANDARD_REQUIRED "ON")
    set(CUDA_MAXRREGCOUNT "128")
endif()

# Add CustomAmdBinary to cmake targets if configured WITH_HIP
if(NOT APPLE AND WITH_HIP AND NOT TARGET CustomAmdBinary)
    add_executable(CustomAmdBinary IMPORTED GLOBAL)
    if(WIN32)
        set(CustomAmdBinaryExecLocation "${CMAKE_BINARY_DIR}/custom_binary/win/CustomAmdBinary.exe")
    else()
        set(CustomAmdBinaryExecLocation "${CMAKE_BINARY_DIR}/custom_binary/linux/CustomAmdBinary")
    endif()
    set_target_properties(CustomAmdBinary PROPERTIES
        IMPORTED_LOCATION "${CustomAmdBinaryExecLocation}"
    )
endif()

# Add cmake-common modules
list(APPEND CMAKE_MODULE_PATH ${FETCH_LOCATION}/cmake-common)

# Load cmake-common macros
include("${FETCH_LOCATION}/cmake-common/braingines.cmake")

# Process each processor
foreach(PROCESSOR ${PROCESSOR_LIST})
    set(PROCESSOR_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../${PROCESSOR}")
    get_filename_component(PROCESSOR_DIR_NAME "${PROCESSOR_DIR}" NAME)
    message(STATUS "Processor dir name: ${PROCESSOR_DIR_NAME}")
    # Parse PROCESSOR file
    file(READ "${PROCESSOR_DIR}/PROCESSOR" PROCESSOR_FILE)
    string(REGEX MATCH "^.*PROCESSOR_IDENTIFIER=[\"]([A-Za-z]+[A-Za-z0-9]*)[\"].*$" UNUSED_MATCH ${PROCESSOR_FILE})
    set(PARSED_PROCESSOR_ID ${CMAKE_MATCH_1})
    message(STATUS "Processor identifier: ${PARSED_PROCESSOR_ID}")

    string(REGEX MATCH "^.*PROCESSOR_DESCRIPTION=[\"]([A-Za-z0-9 ]*)[\"].*$" UNUSED_MATCH ${PROCESSOR_FILE})
    set(PARSED_PROCESSOR_DESCRIPTION ${CMAKE_MATCH_1})
    message(STATUS "Processor description: ${PARSED_PROCESSOR_DESCRIPTION}")

    # Parse VERSION file
    file(READ "${PROCESSOR_DIR}/VERSION" VERSION_FILE)
    string(REGEX MATCH "^.*([0-9]+)\.([0-9]+)\.([0-9]+).*$" UNUSED_MATCH ${VERSION_FILE})
    set(${PROCESSOR_DIR_NAME}_MAJOR_VERSION ${CMAKE_MATCH_1})
    set(${PROCESSOR_DIR_NAME}_MINOR_VERSION ${CMAKE_MATCH_2})
    set(${PROCESSOR_DIR_NAME}_PATCH_LEVEL ${CMAKE_MATCH_3})
    set(${PROCESSOR_DIR_NAME}_BUILD_NUMBER "0")

    # Variables
    set(BG_VERSION_INFO "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}+${${PROCESSOR_DIR_NAME}_BUILD_NUMBER}")
    set(BG_VERSIONINFO_FILEDESCRIPTION "${PARSED_PROCESSOR_DESCRIPTION}")
    set(BG_VERSIONINFO_PRODUCTNAME "${PROCESSOR_DIR_NAME}")
    set(PROJECT_NAME "${PROCESSOR_DIR_NAME}")
    set(cmake-common-${PROJECT_NAME}_SOURCE_DIR "${FETCH_LOCATION}/cmake-common")

    # Getting effect_name from the PROJECT_NAME
    string(REGEX REPLACE "^(.*)_(.*)$" "\\1" effect_name "${PROCESSOR_DIR_NAME}")

    # Add processor subdirectory
    add_subdirectory("${PROCESSOR_DIR}/${PROCESSOR_DIR_NAME}" "${CMAKE_BINARY_DIR}/${PROCESSOR_DIR_NAME}")
endforeach()
