# Avoid including this file several times
include_guard()

message(STATUS "Using Settings from: ${CMAKE_CURRENT_LIST_FILE}")

# Variables
set(BG_VERSION_INFO "${CMAKE_PROJECT_VERSION}+1-1")
set(BG_PRODUCT_NAME "${CMAKE_PROJECT_NAME}")
set(BG_PRODUCT_DESCRIPTION "${CMAKE_PROJECT_DESCRIPTION}")
set(BG_PROJECT_HOMEPAGE "${CMAKE_PROJECT_HOMEPAGE_URL}")

if(APPLE)
    include("${CMAKE_CURRENT_LIST_DIR}/settings_mac.cmake")
else()
    include("${CMAKE_CURRENT_LIST_DIR}/settings_gpu.cmake")
endif()
