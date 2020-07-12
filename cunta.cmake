function (fetch_package_with_database package) 
    include(FetchContent)
    FetchContent_Declare(
        cunta_database
        GIT_REPOSITORY https://github.com/shrumo/cunta.git
    )
    FetchContent_GetProperties(cunta_database)
    if(NOT cunta_database_POPULATED)
        message("Fetching cunta_database")
        FetchContent_Populate(cunta_database)
        include(../cunta/cunta_database.cmake)
    endif()
    find_git_package(${ARGV})
endfunction()
    

function (find_or_fetch_package package)
    if("REQUIRED" IN_LIST ARGV)
        message("maybe do something here, like erase it, because we won't use the fetching at all")
    endif()
    find_package(${ARGV})
    if (NOT ${${package}_FOUND}) 
        fetch_package_with_database(${ARGV})
    endif()
endfunction()
