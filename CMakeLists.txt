cmake_minimum_required(VERSION 3.29.5)

project(gh-action-test
    VERSION 0.0.1
    DESCRIPTION "Testing Github actions using simple C++ project"
    HOMEPAGE_URL "https://github.com/ibis-hdl/gh-actions-test"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Catch2 3 REQUIRED)

add_subdirectory(source)

include(GNUInstallDirs)

# Unit tests
include(CTest)
enable_testing()
add_subdirectory(testsuite)
