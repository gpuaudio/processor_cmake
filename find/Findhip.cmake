# Check perl (used by HIP) and store location in PERL_PATH
if(DEFINED ENV{PERL_PATH})
    cmake_path(CONVERT $ENV{PERL_PATH} TO_CMAKE_PATH_LIST PERL_PATH)

    # Path to folder with perl executable
    set(BG_STRAWBERRYPERL_PATH "${PERL_PATH}")
else()
    message(FATAL_ERROR "PERL_PATH env variable to locate perl executable is not set")
endif()

# HIP
if(DEFINED ENV{HIP_PATH})
    cmake_path(CONVERT $ENV{HIP_PATH} TO_CMAKE_PATH_LIST HIP_ROOT)
else()
    message(FATAL_ERROR "HIP_PATH env variable to locate HIP SDK is not set")
endif()

if(NOT TARGET hip::hip)
    set(CONAN_HIP_CXX_STANDARD "20")
    set(HIP_INCLUDE_PATH "${HIP_ROOT}/include")

    add_library(hip::hip INTERFACE IMPORTED)
    set_target_properties(hip::hip PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${HIP_INCLUDE_PATH}"
    )
    add_library(hip::hip_sdk ALIAS hip::hip)
    message(STATUS "Component target declared: hip::hip")
endif()
