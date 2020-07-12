function (find_git_package package) 
    message("Looking up cunta database for " ${package})
    if (${package} STREQUAL fmt) 
        FetchContent_Declare(
            fmt
            GIT_REPOSITORY https://github.com/fmtlib/fmt.git
            GIT_TAG ${ARG1}
        )
        FetchContent_GetProperties(fmt)
        if(NOT fmt_POPULATED)
          FetchContent_Populate(fmt)
          add_subdirectory(${fmt_SOURCE_DIR} ${fmt_BINARY_DIR})
        endif()
     endif()
endfunction()
