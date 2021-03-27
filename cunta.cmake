function (fetch_package_with_database package) 

    # We first need to make sure we have the database
    include(FetchContent)
    FetchContent_Declare(
        cunta_database
        GIT_REPOSITORY https://github.com/shrumo/cunta.git
    )
    FetchContent_GetProperties(cunta_database)
    if(NOT cunta_database_POPULATED)
        message(VERBOSE "Fetching cunta_database.cmake from git repository.")
        FetchContent_Populate(cunta_database)
        include(${cunta_database_SOURCE_DIR}/cunta_database.cmake)
    endif()

    find_in_cunta_database(${ARGV})
    set(${package}_FOUND_IN_CUNTA ${${package}_FOUND_IN_CUNTA} PARENT_SCOPE)
endfunction()
    
# find_or_fetch_package(<PackageName> [version] [QUIET] [REQUIRED])
macro (find_or_fetch_package package) 
    # We rely on the version being present in ${CUNTA_FIND_OR_FETCH_PACKAGE_UNPARSED_ARGUMENTS}
    cmake_parse_arguments(CUNTA_FIND_OR_FETCH_PACKAGE "QUIET;REQUIRED" "" "" ${ARGN})
    set(${package}_FOUND 0)

    # Try looking for the package in submodules
    find_package(Git QUIET)
    if(${GIT_FOUND} AND EXISTS "${PROJECT_SOURCE_DIR}/.git" AND EXISTS "${PROJECT_SOURCE_DIR}/extern/${package}")
        add_subdirectory("${PROJECT_SOURCE_DIR}/extern/${package}") 
        set(${package}_FOUND 1)
        if(NOT CUNTA_FIND_OR_FETCH_PACKAGE_QUIET)
            message(STATUS "${package} found as a submodule")
        endif()
    endif()

    if(NOT ${${package}_FOUND})
        # Try looking for the package in system packages        
        find_package(${package} ${CUNTA_FIND_OR_FETCH_PACKAGE_UNPARSED_ARGUMENTS} QUIET)
        if(${${package}_FOUND})
            if(NOT CUNTA_FIND_OR_FETCH_PACKAGE_QUIET)
                message(STATUS "${package} found in system packages")
            endif()
            set(${package}_FOUND 1)
        endif()
    endif()
   
    if(NOT ${${package}_FOUND})	
        # Try looking for the package in the database
        fetch_package_with_database(${ARGV})
        if (${${package}_FOUND_IN_CUNTA})
            if(NOT CUNTA_FIND_OR_FETCH_PACKAGE_QUIET)
                message(STATUS "${package} was found in cunta database")
            endif()
            set(${package}_FOUND 1)
        endif()
    endif()

    if(NOT ${${package}_FOUND})
        # Report error if the package is not found
        if(CUNTA_FIND_OR_FETCH_PACKAGE_REQUIRED)
                message(FATAL_ERROR "${package} not found.")
        else()
            if(NOT CUNTA_FIND_OR_FETCH_PACKAGE_QUIET)
                message(STATUS "${package} not found.")
            endif()
        endif()
    endif()    
endmacro()
