# cunta

[![Build Status](https://travis-ci.com/shrumo/cunta.svg?branch=master)](https://travis-ci.com/shrumo/cunta)

This provides a CMake function, simililar to `find_package`, that will
also fetch the packages from git (using `FetchContent`) that are not found. 

You probably **don't** want to use this. Probably, you'd be better of with [Conan](https://conan.io/),
 [vcpkg](https://github.com/microsoft/vcpkg), or other package managers. This builds the packages,
offers no caching across projects and is generally just to improve prototyping speed.

## Example projects

Ready to use, complete projects including various libraries can be found here:

* [bgfx](https://github.com/shrumo/cunta/tree/master/tests/bgfx)
* [glfw](https://github.com/shrumo/cunta/tree/master/tests/glfw)
* [raylib](https://github.com/shrumo/cunta/tree/master/tests/raylib)

## Usage

Imagine you want to get the great [fmt](https://github.com/fmtlib/fmt).

If you have cunta setup you would just write (in your `CMakeLists.txt`):

```CMake
include(cmake/cunta.cmake)

find_or_fetch_package(fmt)
```

And that's it! You will use fmt from your system, if it is available and if not you will build it from sources.
It will also look into `extern` directory whether the package is there as a git submodule.

**But where does it take the package from?**

1. It checks the submodules in `extern/` to try and find package there (add it as [add_subdirectory](https://cmake.org/cmake/help/latest/command/add_subdirectory.html) if that is the case)
2. If it's not found in submodules it looks for tha package with [find_package](https://cmake.org/cmake/help/latest/command/find_package.html).
3. If it's not found in submodules and not in the system, then it fetches the git repository (with [fetch_content](https://cmake.org/cmake/help/latest/module/FetchContent.html)) into and does [add_subdirectory](https://cmake.org/cmake/help/latest/command/add_subdirectory.html) on it.

## Dependencies

CMake 3.11 and above and git for packages that require submodules.
Also, you need to be able to build those packages themselves.

## Adding stuff

If you are interested (but I doubt it), feel free to send Pull Requests with more packages/fixes/ideas/anything.

## Setup

### TL;DR

The setup is just downloading somehow the `cunta.cmake` file and making sure it is included from your CMakeLists.txt
(for example if cunta.cmake is in cmake directory you would add `include(cmake/cunta.cmake`)

### Step by step

You have a project:

```console
.
├── main.cpp
└─── CMakeLists.txt
```

You first get the cunta.cmake file somehow.

```bash
wget https://raw.githubusercontent.com/shrumo/cunta/master/cunta.cmake
```

And put it inside cmake folder. (or whatever, just be able to reach it
with `CMakeLists.txt`) You can also use `FetchContent` to fetch the
`cunta.cmake` file. Or even just clone it as a [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

So you have it somewhere:

```console
.
├── main.cpp
├─── CMakeLists.txt
└── cmake
    └── cunta.cmake
```

Then in your `CMakeLists.txt` you do:

```CMake
include(cmake/cunta.cmake)
```

## Currently supported

* [fmt](https://github.com/fmtlib/fmt)
* [glfw3](https://github.com/glfw/glfw)
* [bgfx](https://github.com/bkaradzic/bgfx.cmake)
* [glm](https://github.com/g-truc/glm)
* [raylib](https://github.com/raysan5/raylib)
* [Protobuf](https://github.com/protocolbuffers/protobuf)
* [owl](https://github.com/shrumo/owl-cmake)
* [absl](https://github.com/abseil/abseil-cpp)

## Known problems

If the project shares a dependency with other imported package there might be a conflict. Example:

```CMake
find_or_fetch_package(raylib)
find_or_fetch_package(glfw)
```

Leads to:

```console
CMake Error at build/_deps/raylib-src/src/external/glfw/src/CMakeLists.txt:96 (add_library):
  add_library cannot create target "glfw" because an imported target with the
  same name already exists.
```

This can be solved in various ways. One of them is use the target provided by the other target.
Some other ugly hack might be to redefine `add_subdirectory`. (but we [shouldn't redefine CMake commands](https://crascit.com/2018/09/14/do-not-redefine-cmake-commands/))
If anyone cares I will solve it.

## Debugging problems

We use [VERBOSE CMake messages](https://cmake.org/cmake/help/latest/command/message.html#general-messages) to provide more information on where the things are actually fetched from. To see the VERBOSE lines use:

```bash
cmake .. --log-level=VERBOSE
```

It might also be useful to [print all the properties of a target](https://stackoverflow.com/questions/32183975/how-to-print-all-the-properties-of-a-target-in-cmake) to verify the include paths and other properties are correct.
