# Sets up the database for things that are simple to fetch from git
function (setup_cunta_database) 
    # fmt, added by shrumo, MIT license
    list(APPEND cunta_database "fmt https://github.com/fmtlib/fmt.git") 
    # glfw3, added by shrumo, zlib/libpng
    list(APPEND cunta_database "glfw3 https://github.com/glfw/glfw.git")
    # glm, added by shrumo, Happy Bunny License (MIT, but you need to keep bunnies happy)
    list(APPEND cunta_database "glm https://github.com/g-truc/glm.git")
    # raylib, added by shrumo, zlib
    list(APPEND cunta_database "raylib https://github.com/raysan5/raylib.git")
    # protobuf, added by shrumo, Google 
    list(APPEND cunta_database "Protobuf https://github.com/protocolbuffers/protobuf.git")

    set(cunta_database ${cunta_database} PARENT_SCOPE)
endfunction()

# Looks for the package in a list of predefined git repositories.
# Functions like a database saying how each project is defined and
# can be fetched.
# find_git_package(<package> [version] [QUIET] [REQUIRED])
function (find_git_package package) 
    setup_cunta_database()

    # Parse the first non specified argument
    if(${ARGC} GREATER "0")
        if(${ARGV1} MATCHES "^[0-9]*(\.[0-9]*(\.[0-9]*(\.[0-9]*)))$") 
            set(version ${ARGV1})
        endif()
    endif()

    message("Looking up cunta database for " ${package} " " ${version})

    # Set the found variable to false 
    set(${package}_GIT_FOUND 0 PARENT_SCOPE)

    # bgfx, added by shrumo, BSD 2-Clause
    if (${package} STREQUAL "bgfx")
        find_package(Git QUIET)
        
        message("bgfx was found in https://github.com/widberg/bgfx.cmake.git")
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

        add_subdirectory(${bgfx_SOURCE_DIR} ${bgfx_BINARY_DIR} EXCLUDE_FROM_ALL)

        set(${package}_GIT_FOUND 1 PARENT_SCOPE)
        message("bgfx added as a target")
        return()
    endif()

    # protobuf, added by shrumo, Google 
    if (${package} STREQUAL "Protobuf") 
        message("Protobuf was found in https://github.com/protocolbuffers/protobuf.git")
        FetchContent_Declare(
            Protobuf
            GIT_REPOSITORY https://github.com/protocolbuffers/protobuf.git
            GIT_TAG ${version}
        )
        FetchContent_GetProperties(Protobuf)
        if(NOT protobuf_POPULATED)
            FetchContent_Populate(Protobuf)
            add_subdirectory(${protobuf_SOURCE_DIR}/cmake ${protobuf_BINARY_DIR} EXCLUDE_FROM_ALL)
        endif()
        set(${package}_GIT_FOUND 1 PARENT_SCOPE)
        return()
    endif()

    foreach(entry IN LISTS cunta_database)
        separate_arguments(entry)
        list(GET entry 0 name)
        list(GET entry 1 path)
        
        if (${package} STREQUAL ${name}) 
            message("${name} was found in ${path}")
            FetchContent_Declare(
                ${name}
                GIT_REPOSITORY ${path}
                GIT_TAG ${version}
            )
            FetchContent_GetProperties(${name})
            if(NOT ${name}_POPULATED)
                FetchContent_Populate(${name})
                add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
            endif()
            set(${package}_GIT_FOUND 1 PARENT_SCOPE)
            return()
        endif()
    endforeach(entry) 

    
endfunction()
