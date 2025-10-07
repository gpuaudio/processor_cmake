message(STATUS "Using Settings from: ${CMAKE_CURRENT_LIST_FILE}")

# Variables set here
# METAL_NO_FAST_MATH
# MAC_OSX_SDK_VER
# CMAKE_OSX_DEPLOYMENT_TARGET
# BG_METAL_VERSION
# METAL_CPP_URL
set(METAL_NO_FAST_MATH "False")

if("${CMAKE_OSX_SYSROOT}" STREQUAL "")
    execute_process(COMMAND xcrun --sdk macosx --show-sdk-path
        OUTPUT_VARIABLE CMAKE_OSX_SYSROOT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

if("${CMAKE_OSX_SYSROOT}" STREQUAL "")
    message(FATAL_ERROR "Could not determine SDK path")
endif()  

get_filename_component(TARGET_SDK ${CMAKE_OSX_SYSROOT} NAME)
string(REGEX MATCH "^.*MacOSX(([0-9]*\.)?[0-9]+)\.sdk$" UNUSED_MATCH ${TARGET_SDK})
if("${CMAKE_MATCH_1}" STREQUAL "")
    message(FATAL_ERROR "Could not determine SDK version")
endif()

set(MAC_OSX_SDK_VER ${CMAKE_MATCH_1})
message(STATUS "MacOSX SDK version ${MAC_OSX_SDK_VER}")

if(${MAC_OSX_SDK_VER} VERSION_LESS "13.0")
    message(FATAL_ERROR "MacOSX SDK < 13.0 not supported")
elseif(${MAC_OSX_SDK_VER} VERSION_GREATER "26.0")
    message(FATAL_ERROR "MacOSX SDK > 26.0 not supported")
endif()

# select minimum deployment target
set(DEPLOYMENT_TARGET ${MAC_OSX_SDK_VER} CACHE STRING "MacOS version the binaries can be deployed on")
if(${DEPLOYMENT_TARGET} VERSION_LESS "13.0")
    message(WARNING "DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET} < 13.0 not supported. Using DEPLOYMENT_TARGET 13.0")
    set(DEPLOYMENT_TARGET "13.0")
elseif(${DEPLOYMENT_TARGET} VERSION_GREATER ${MAC_OSX_SDK_VER})
    message(WARNING "DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET} > ${MAC_OSX_SDK_VER} not supported with current MacOS SDK. Using DEPLOYMENT_TARGET ${MAC_OSX_SDK_VER}")
    set(DEPLOYMENT_TARGET ${MAC_OSX_SDK_VER})
endif()
set(CMAKE_OSX_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET})
message(STATUS "Minimum deployment target set to ${CMAKE_OSX_DEPLOYMENT_TARGET}")

# select metal shading language version
if(${CMAKE_OSX_DEPLOYMENT_TARGET} VERSION_GREATER_EQUAL "26.0")
    set(BG_METAL_VERSION "metal4.0")
elseif(${CMAKE_OSX_DEPLOYMENT_TARGET} VERSION_GREATER_EQUAL "15.0")
    set(BG_METAL_VERSION "metal3.2")
elseif(${CMAKE_OSX_DEPLOYMENT_TARGET} VERSION_GREATER_EQUAL "14.0")
    set(BG_METAL_VERSION "metal3.1")
elseif(${CMAKE_OSX_DEPLOYMENT_TARGET} VERSION_GREATER_EQUAL "13.0")
    set(BG_METAL_VERSION "metal3.0")
endif()
message(STATUS "Shading language version set to ${BG_METAL_VERSION}")

# select metal-cpp version
if(${MAC_OSX_SDK_VER} VERSION_GREATER_EQUAL "26.0")
    set(METAL_CPP_ARCHIVE "metal-cpp_macOS26_iOS26-beta2.zip")
elseif(${MAC_OSX_SDK_VER} VERSION_GREATER_EQUAL "15.2")
    set(METAL_CPP_ARCHIVE "metal-cpp_macOS15.2_iOS18.2.zip")
elseif(${MAC_OSX_SDK_VER} VERSION_GREATER_EQUAL "15.0")
    set(METAL_CPP_ARCHIVE "metal-cpp_macOS15_iOS18.zip")
elseif(${MAC_OSX_SDK_VER} VERSION_GREATER_EQUAL "14.2")
    set(METAL_CPP_ARCHIVE "metal-cpp_macOS14.2_iOS17.2.zip")
elseif(${MAC_OSX_SDK_VER} VERSION_GREATER_EQUAL "14.0")
    set(METAL_CPP_ARCHIVE "metal-cpp_macOS14_iOS17-beta.zip")
elseif(${MAC_OSX_SDK_VER} VERSION_GREATER_EQUAL "13.3")
    set(METAL_CPP_ARCHIVE "metal-cpp_macOS13.3_iOS16.4.zip")
elseif(${MAC_OSX_SDK_VER} VERSION_GREATER_EQUAL "13.0")
    set(METAL_CPP_ARCHIVE "metal-cpp_macOS13_iOS16.zip")
endif()
set(METAL_CPP_URL "https://developer.apple.com/metal/cpp/files/${METAL_CPP_ARCHIVE}")
