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

    fetch_from_cunta_database(${ARGV})
    set(${package}_FOUND_IN_CUNTA ${${package}_FOUND_IN_CUNTA} PARENT_SCOPE)
    set(${package}_CUNTA_FETCHED_DIRECTORIES ${${package}_CUNTA_FETCHED_DIRECTORIES} PARENT_SCOPE)
endfunction()
    

macro (find_or_fetch_package package) 
    # Try looking for the package in submodules
    find_package(Git QUIET)
    if(${GIT_FOUND} AND EXISTS "${PROJECT_SOURCE_DIR}/.git" AND EXISTS "${PROJECT_SOURCE_DIR}/extern/${package}")
	    add_subdirectory("${PROJECT_SOURCE_DIR}/extern/${package}") 
        set(${package}_FOUND 1)
        if(NOT "QUIET" IN_LIST ARGV)
            message(STATUS "${package} found as a submodule")
        endif()
        return()
    endif()

    # Use a weird name for this variable to make sure there is no collision in
    # the scope. This allows this to be macro. This name is unset in each path.
    set(__cunta_${package}_required__ 0)
    if("REQUIRED" IN_LIST ARGV)
        set(__cunta_${package}_required__ 1)
        list(REMOVE_ITEM ARGV "REQUIRED")
    endif()

    # Try looking for the package in system packages
    find_package(${ARGV} QUIET)
    if(${${package}_FOUND})
        if(NOT "QUIET" IN_LIST ARGV)
            message(STATUS "${package} found in system packages")
        endif()
        unset(__cunta_${package}_required_)
        set(${package}_FOUND 1)
        return()
    endif()	
    
    # Try looking for the package in the database
    fetch_package_with_database(${ARGV})
    if (${${package}_FOUND_IN_CUNTA})
        if(NOT "QUIET" IN_LIST ARGV)
            message(STATUS "${package} was found in cunta database")
        endif()
        add_subdirectory(${${package}_CUNTA_FETCHED_DIRECTORIES} EXCLUDE_FROM_ALL)
        set(${package}_FOUND 1)
        unset(__cunta_${package}_required_)
        return() 
    endif()

    # Report error if the package is not found
    if(${__cunta_${package}_required__})
            message(FATAL_ERROR "${package} not found.")
    else()
        if(NOT "QUIET" IN_LIST ARGV)
            message(STATUS "${package} not found.")
        endif()
    endif()
    
    unset(__cunta_${package}_required_)
    set(${package}_FOUND} 0)
endmacro()
