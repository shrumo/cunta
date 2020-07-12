# Looks for the package in a list of predefined git repositories.
# Functions like a database saying how each project is defined and
# can be fetched.
# find_git_package(<package> [version] [QUIET] [REQUIRED])
function (find_git_package package) 
    message("Looking up cunta database for " ${package} " " ${version})

    # Parse the first non specified argument
    if(${ARGC} GREATER "0")
        if(${ARGV1} MATCHES "^[0-9]*(\.[0-9]*(\.[0-9]*(\.[0-9]*)))$") 
            set(version ${ARGV1})
        endif()
    endif()

    # Set the found variable to false 
    set(${package}_GIT_FOUND 0 PARENT_SCOPE)

    # fmt, added by shrumo
    if (${package} STREQUAL fmt) 
        message("fmt was found, looking for version " ${version})
        FetchContent_Declare(
            fmt
            GIT_REPOSITORY https://github.com/fmtlib/fmt.git
            GIT_TAG ${version}
        )
        FetchContent_GetProperties(fmt)
        if(NOT fmt_POPULATED)
          FetchContent_Populate(fmt)
          add_subdirectory(${fmt_SOURCE_DIR} ${fmt_BINARY_DIR})
        endif()
        set(${package}_GIT_FOUND 1 PARENT_SCOPE)
    endif()

    # glfw3, added by shrumo
    if (${package} STREQUAL glfw3)
        message("glfw3 was found, looking for version " ${version})
        FetchContent_Declare(
            glfw3
            GIT_REPOSITORY https://github.com/glfw/glfw.git
            GIT_TAG ${version}
        )
        FetchContent_GetProperties(glfw3)
        if(NOT glfw3_POPULATED)
          FetchContent_Populate(glfw3)
          add_subdirectory(${glfw3_SOURCE_DIR} ${glfw3_BINARY_DIR})
        endif()
        set(${package}_GIT_FOUND 1 PARENT_SCOPE)
    endif()

    # Respond with correct messages if package was not found
    if(NOT ${${package}_GIT_FOUND})
        set(message_level "STATUS")
        if("REQUIRED" IN_LIST ARGV)
            set(message_level "FATAL_ERROR")
        endif()
        if(NOT "QUIET" IN_LIST ARGV) 
            message(${message_level} ${package} " not found.") 
        endif()
    endif()
endfunction()
