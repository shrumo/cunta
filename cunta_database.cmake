# Sets up the database for things that are simple to fetch from git
function (setup_cunta_database) 
    # fmt, added by shrumo, MIT license
    list(APPEND cunta_database "PACKAGE fmt LINK https://github.com/fmtlib/fmt.git") 
    # glfw3, added by shrumo, zlib/libpng
    list(APPEND cunta_database "PACKAGE glfw3 LINK https://github.com/glfw/glfw.git")
    # raylib, added by shrumo, zlib
    list(APPEND cunta_database "PACKAGE raylib LINK https://github.com/raysan5/raylib.git")
    # protobuf, added by shrumo, Google 
    list(APPEND cunta_database "PACKAGE Protobuf LINK https://github.com/protocolbuffers/protobuf.git")
    # owl, added by shrumo, MIT
    list(APPEND cunta_database "PACKAGE owl LINK https://github.com/shrumo/owl-cmake.git DEFAULT_TAG main")
    set(cunta_database ${cunta_database} PARENT_SCOPE)
endfunction()

# Looks for the package in a list of predefined places.
# Sets one variable in the parent scope:
#   ${package}_FOUND_IN_CUNTA - whether the package was found in the database
# This will do add_subdirectory on the fetched thing, to expose targets from the dependency.
# find_in_cunta_database(<package> [version] [QUIET] [REQUIRED])
function (find_in_cunta_database package) 
    setup_cunta_database()

    # We rely on the version being present in ${CUNTA_FIND_IN_CUNTA_DATABASE_UNPARSED_ARGUMENTS}
    cmake_parse_arguments(CUNTA_FIND_IN_CUNTA_DATABASE "QUIET;REQUIRED" "" "" ${ARGN})

    message(VERBOSE "Looking up cunta database for ${package} ${CUNTA_FIND_IN_CUNTA_DATABASE_UNPARSED_ARGUMENTS}")

    # Set the found variable to false 
    set(${package}_FOUND_IN_CUNTA 0 PARENT_SCOPE)

    # bgfx, added by shrumo, BSD 2-Clause
    if (${package} STREQUAL "bgfx")
        find_package(Git QUIET)
        
        message(VERBOSE "bgfx was found in https://github.com/bkaradzic/bgfx.cmake.git")
        if(NOT GIT_FOUND)
            message(VERBOSE "bgfx requires git to be build by cunta")
        endif()

        FetchContent_Declare(
            bgfx
            GIT_REPOSITORY https://github.com/bkaradzic/bgfx.cmake.git
        )
        # Fetch the content 
        FetchContent_GetProperties(bgfx)
        if(NOT bgfx_POPULATED)
          	FetchContent_Populate(bgfx)

          	# We need to initialize the submodules 
        	# Update submodules as needed
        	execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                        WORKING_DIRECTORY ${bgfx_SOURCE_DIR}
                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
        	if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            	message(VERBOSE "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout bgfx submodules manually")
        	endif()
        	add_subdirectory(${bgfx_SOURCE_DIR} ${bgfx_BINARY_DIR} EXCLUDE_FROM_ALL)
        endif()       
        set(${package}_FOUND_IN_CUNTA 1 PARENT_SCOPE)
        return()
    endif()

    # protobuf, added by shrumo, Google 
    if (${package} STREQUAL "Protobuf") 
        message(VERBOSE "Protobuf was found in https://github.com/protocolbuffers/protobuf.git")
        FetchContent_Declare(
            Protobuf
            GIT_REPOSITORY https://github.com/protocolbuffers/protobuf.git
            GIT_TAG ${CUNTA_FIND_IN_CUNTA_DATABASE_UNPARSED_ARGUMENTS}
        )
        FetchContent_GetProperties(Protobuf)
        if(NOT protobuf_POPULATED)
            FetchContent_Populate(Protobuf)
            add_subdirectory(${protobuf_SOURCE_DIR}/cmake ${protobuf_BINARY_DIR} EXCLUDE_FROM_ALL)       
        endif()
        set(${package}_FOUND_IN_CUNTA 1 PARENT_SCOPE)
        return()
    endif()

    # glm, added by shrumo, Happy Bunny License (MIT, but you need to keep bunnies happy)
    if (${package} STREQUAL "glm") 
	    message(VERBOSE "glm was found in glm https://github.com/g-truc/glm.git")
	    FetchContent_Declare(
		    glm
		    GIT_REPOSITORY https://github.com/g-truc/glm.git
		    GIT_TAG ${CUNTA_FIND_IN_CUNTA_DATABASE_UNPARSED_ARGUMENTS}
	    )
	    FetchContent_GetProperties(glm)
	    if(NOT glm_POPULATED)
		    FetchContent_Populate(glm)
		    add_subdirectory(${glm_SOURCE_DIR} ${glm_BINARY_DIR} EXCLUDE_FROM_ALL)
            # A trick to make link glm headers to the target properly
            target_include_directories(glm INTERFACE $<BUILD_INTERFACE:${glm_SOURCE_DIR}>) 
	    endif()
	    set(${package}_FOUND_IN_CUNTA 1 PARENT_SCOPE)
	    return()
    endif()

    foreach(entry IN LISTS cunta_database)
        string(REPLACE " " ";" entry_list ${entry})
        cmake_parse_arguments(CUNTA_ENTRY "" "PACKAGE;LINK;DEFAULT_TAG" "" ${entry_list}) 

        set(tag ${CUNTA_ENTRY_DEFAULT_TAG})
        if(DEFINED ${CUNTA_FIND_IN_CUNTA_DATABASE_UNPARSED_ARGUMENTS})
            set(tag ${CUNTA_FIND_IN_CUNTA_DATABASE_UNPARSED_ARGUMENTS})
        endif()
        
        if (${package} STREQUAL ${CUNTA_ENTRY_PACKAGE}) 
            message(VERBOSE "${package} was found in ${path}")
            FetchContent_Declare(
                ${CUNTA_ENTRY_PACKAGE}
                GIT_REPOSITORY ${CUNTA_ENTRY_LINK}
                GIT_TAG ${tag}
            )
            FetchContent_GetProperties(${CUNTA_ENTRY_PACKAGE})
            if(NOT ${CUNTA_ENTRY_PACKAGE}_POPULATED)
                FetchContent_Populate(${CUNTA_ENTRY_PACKAGE})
                add_subdirectory(${${CUNTA_ENTRY_PACKAGE}_SOURCE_DIR} ${${CUNTA_ENTRY_PACKAGE}_BINARY_DIR} EXCLUDE_FROM_ALL)
            endif()
            set(${package}_FOUND_IN_CUNTA 1 PARENT_SCOPE)
            return()
        endif()
    endforeach(entry) 
endfunction()
