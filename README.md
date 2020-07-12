# cunta

[![Build Status](https://travis-ci.com/shrumo/cunta.svg?branch=master)](https://travis-ci.com/shrumo/cunta)

This provides a CMake function, simililar to `find_package`, that will
also fetch the packages from git (using `FetchContent`) that are not found. 

You probably don't want to use this. Probably, you'd be better of with [Conan](https://conan.io/),
 [vcpkg](https://github.com/microsoft/vcpkg), or other package managers.

I just started working on this and I have no idea whether this is possible, so don't hate. Thanks.

## Example

Imagine you want to get the great [fmt](https://github.com/fmtlib/fmt) (the only supported library now).

If you have cunta setup you would just write (in your `CMakeLists.txt`):

```
include(cmake/cunta.cmake)

find_or_fetch_package(fmt)
```

And that's it! You will use fmt from your system, if it is available and if not you will build it from sources.

## Dependencies

CMake 3.11 and above.

## Setup

TL;DR

The setup is just downloading somehow the `cunta.cmake` file and making sure it is included from your CMakeLists.txt.

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
