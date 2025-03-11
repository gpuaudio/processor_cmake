cmake_minimum_required(VERSION 3.24)

macro(gpuaudio_provide_dependency method dep_name)
    if("${method}" STREQUAL "FIND_PACKAGE")
        # Blacklist these due to misleading "Package not found" cmake warnings
        set(blacklist_ "hip_sdk;GTest")

        set(args_ "${ARGN}")
        list(FIND args_ "CONFIG" idx_)
        if(${idx_} GREATER -1)
            list(REMOVE_ITEM args_ "CONFIG")
            list(INSERT args_ ${idx_} "MODULE")
            list(APPEND args_ "QUIET")
        endif()

        list(FIND blacklist_ "${dep_name}" idx_)
        if(${idx_} GREATER -1)
            set(${dep_name}_FOUND True)
        else()
            list(APPEND args_ "BYPASS_PROVIDER")
            find_package(${dep_name} ${args_})
        endif()
    endif()
endmacro()

cmake_language(
    SET_DEPENDENCY_PROVIDER gpuaudio_provide_dependency
    SUPPORTED_METHODS FIND_PACKAGE
)
