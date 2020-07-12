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

    # fmt, added by shrumo, MIT license
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
        message("fmt::fmt added as a target")
    endif()

    # glfw3, added by shrumo, zlib/libpng
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
        message("glfw added as a target")
    endif()

    # bgfx, added by shrumo, BSD 2-Clause
    if (${package} STREQUAL bgfx)
        find_package(Git QUIET)
        
        message("bgfx was found, there is only one version")
        if(NOT GIT_FOUND)
            message(STATUS "bgfx requires git to be build by cunta")
        endif()
        FetchContent_Declare(
            bgfx
            GIT_REPOSITORY https://github.com/widberg/bgfx.cmake.git
        )
    
        # Fetch the content 
        FetchContent_GetProperties(bgfx)
        if(NOT bgfx_POPULATED)
          FetchContent_Populate(bgfx)
        endif()       

        # We need to initialize the submodules 
        # Update submodules as needed
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                        WORKING_DIRECTORY ${bgfx_SOURCE_DIR}
                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout bgfx submodules manually")
        endif()

        add_subdirectory(${bgfx_SOURCE_DIR} ${bgfx_BINARY_DIR})

        set(${package}_GIT_FOUND 1 PARENT_SCOPE)
        message("bgfx added as a target")
    endif()

    # glm, added by shrumo, Happy Bunny License (MIT, but you need to keep bunnies happy)
    if (${package} STREQUAL glm)
        message("glm was found, looking for version " ${version})
        FetchContent_Declare(
            glm
            GIT_REPOSITORY https://github.com/g-truc/glm.git
            GIT_TAG ${version}
        )
        FetchContent_GetProperties(glm)
        if(NOT glm_POPULATED)
          FetchContent_Populate(glm)
          add_subdirectory(${glm_SOURCE_DIR} ${glm_BINARY_DIR})
        endif()
        set(${package}_GIT_FOUND 1 PARENT_SCOPE)
        message("glm::glm added as a target")
    endif()

    # raylib, added by shrumo, zlib
    if (${package} STREQUAL raylib)
        message("raylib was found, looking for version " ${version})
        FetchContent_Declare(
            raylib
            GIT_REPOSITORY https://github.com/raysan5/raylib.git
            GIT_TAG ${version}
        )
        FetchContent_GetProperties(raylib)
        if(NOT raylib_POPULATED)
          FetchContent_Populate(raylib)
          add_subdirectory(${raylib_SOURCE_DIR} ${raylib_BINARY_DIR})
        endif()
        set(${package}_GIT_FOUND 1 PARENT_SCOPE)
        message("raylib added as a target")
    endif()

endfunction()
