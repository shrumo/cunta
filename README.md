# cunta

[![Build Status](https://travis-ci.com/shrumo/cunta.svg?branch=master)](https://travis-ci.com/shrumo/cunta)

This provides a CMake function, simililar to `find_package`, that will
also fetch the packages from git (using `FetchContent`) that are not found. 

You probably **don't** want to use this. Probably, you'd be better of with [Conan](https://conan.io/),
 [vcpkg](https://github.com/microsoft/vcpkg), or other package managers. This builds the packages,
offers no caching across projects and is generally just to improve prototyping speed.

## Example

Imagine you want to get the great [fmt](https://github.com/fmtlib/fmt).

If you have cunta setup you would just write (in your `CMakeLists.txt`):

```
include(cmake/cunta.cmake)

find_or_fetch_package(fmt)
```

And that's it! You will use fmt from your system, if it is available and if not you will build it from sources.

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

```
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

```
.
├── main.cpp
├─── CMakeLists.txt
└── cmake
    └── cunta.cmake
```

Then in your `CMakeLists.txt` you od:

```
include(cmake/cunta.cmake)
```


## Currently supported

* fmt
* glfw3
* bgfx
* glm
* raylib
* Protobuf


## Problems

There is a problem, when a target with the same name is created by a previous import
you cannot create it with the current import. Example:

```
find_or_fetch_package(raylib)
find_or_fetch_package(glfw)
```

Leads to:

```
CMake Error at build/_deps/raylib-src/src/external/glfw/src/CMakeLists.txt:96 (add_library):
  add_library cannot create target "glfw" because an imported target with the
  same name already exists.
```

This can be solved in various ways. One of them is use the target provided by the other target.
Some other ugly hack might be to redefine `add_subdirectory`. (but we [shouldn't redefine CMake commands](https://crascit.com/2018/09/14/do-not-redefine-cmake-commands/))
If anyone cares I will solve it. 
