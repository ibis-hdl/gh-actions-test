cmake_minimum_required(VERSION 3.28)

project(gh-action-test
    VERSION 0.0.1
    DESCRIPTION "Testing Github actions on simple C++ project"
    HOMEPAGE_URL "https://github.com/ibis-hdl/gh-actions-test"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

## CMake config modules from Conan2
# Mote:
# - Conan's path differ at Windows and Linux/macOS
if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CMAKE_CONAN_CONFIG_PATH build/conan/build/${CMAKE_BUILD_TYPE}/generators)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(CMAKE_CONAN_CONFIG_PATH build/conan/build/generators)
elsif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_CONAN_CONFIG_PATH build/conan/build/${CMAKE_BUILD_TYPE}/generators)
else()
    message(FATAL_ERROR "CMAKE_SYSTEM_NAME >>> ${CMAKE_SYSTEM_NAME} <<< *not* supported.")
endif()

list(PREPEND CMAKE_PREFIX_PATH ${CMAKE_CONAN_CONFIG_PATH})

find_package(Catch2 3 REQUIRED)

add_subdirectory(source)

include(GNUInstallDirs)

# Unit tests
include(CTest)
add_subdirectory(testsuite)
