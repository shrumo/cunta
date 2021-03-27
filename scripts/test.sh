#!/bin/bash

PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."

# Go through each test and try building it with the usual commands
SUCCESS=true
for package_test in $(ls ${PROJECT_SOURCE_DIR}/tests/)
do
    case ${package_test} in
	    "README.md") continue;;
	    "glfw"|"raylib"|"bgfx","raylib_glm_fmt") if [ ! -z ${CI} ]; then continue; fi;; # Omit some tests in CI, as they require a display
            *)
    esac
    echo "----- Testing ${package_test} -----"
    cd ${PROJECT_SOURCE_DIR}/tests/${package_test}

    ./scripts/clean.sh
    if [[ $? -ne 0 ]]
    then
    echo "${package_test} failed on running scripts/clean.sh"
        SUCCESS=false
        continue
    fi

    ./scripts/build.sh
    if [[ $? -ne 0 ]]
    then
    echo "${package_test} failed on running scripts/build.sh"
        SUCCESS=false
        continue
    fi

    ./scripts/run.sh
    if [[ $? -ne 0 ]]
    then
        echo "${package_test} failed on running scripts/run.sh"
        SUCCESS=false
        continue
    fi

    ./scripts/clean.sh
    if [[ $? -ne 0 ]]
    then
    echo "${package_test} failed on running scripts/clean.sh"
        SUCCESS=false
        continue
    fi

    echo "${package_test} succeeded"
done


# Print the result and leave with bad exit code if it failed
if $SUCCESS 
then
    echo "Tests succeeded"
else
    echo "Tests failed"
    exit 1
fi
