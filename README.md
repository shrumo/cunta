# cunta

This provides a CMake function, simililar to `find_package`, that will
also fetch the packages from git (using `FetchContent`) that are not found. 

You probably don't want to use this. Probably, you'd be better of with [Conan](https://conan.io/),
 [vcpkg](https://github.com/microsoft/vcpkg), or other package managers.

I just started working on this and I have no idea whether this is possible, so don't hate. Thanks.
