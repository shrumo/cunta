function (fetch_package_with_database package) 
    include(FetchContent)
    FetchContent_Declare(
        cunta_database
        GIT_REPOSITORY https://github.com/shrumo/cunta.git
    )
    FetchContent_GetProperties(cunta_database)
    if(NOT cunta_database_POPULATED)
      FetchContent_Populate(cunta_database)
     include(../cunta/cunta_database.cmake)
    endif()
    find_git_package(${ARGV})
endfunction()
    


function (find_or_fetch_package package)
    if("REQUIRED" IN_LIST ARGV)
        message("maybe do something here, like erase it")
    endif()
    find_package(${ARGV})
    if (NOT TARGET ${package}) 
        fetch_package_with_database(${ARGV})
    endif()
endfunction()
