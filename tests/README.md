# cunta tests

Each directory corresponds to one test. 
It should contains scripts/build.sh, scripts/run.sh and scripts/clean.sh. For testing
all scripts will be run (clean, build, run, clean) and any non zero exit code will be 
treated as a failure.

The tests can be run with scripts/test.sh.
