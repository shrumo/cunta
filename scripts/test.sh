#!/bin/bash -v

SCRIPT_LOCATION="$(pwd)/${0%/*}"

# Go through each test and try building it
SUCCESS=true
for package_test in $(ls ../tests)
do
    if [[ "$package_test" = 'README.md' ]]
    then
        continue
    fi
    echo "----- Testing  $package_test -----"
    cd ${SCRIPT_LOCATION}
    cd ../tests/$package_test

    # Cleanup previous runs
    rm build -rf

    # Do the usual CMake building steps and verify they succeed
    mkdir build
    cd build
    cmake .. 
    if [[ $? -ne 0 ]]
    then
        echo "${package_test} failed on cmake .."
        SUCCESS=false
        continue
    fi
    make -j4
    if [[ $? -ne 0 ]]
    then
        echo "${package_test} failed on make"
        SUCCESS=false
        continue
    fi
    ./run
    if [[ $? -ne 0 ]]
    then
        echo "${package_test} failed on running"
        SUCCESS=false
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
