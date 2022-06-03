cmake_minimum_required(VERSION 3.20)

project(gh-action-test
    VERSION 0.0.1
    DESCRIPTION "Testing Github actions on simple C++ project"
    HOMEPAGE_URL "https://github.com/ibis-hdl/gh-actions-test"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

list(APPEND
    CMAKE_MODULE_PATH
        ${CMAKE_BINARY_DIR} # conan
)

find_package(Python3 COMPONENTS Interpreter REQUIRED)
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    file(DOWNLOAD
        "https://raw.githubusercontent.com/conan-io/cmake-conan/0.18.1/conan.cmake"
        "${CMAKE_BINARY_DIR}/conan.cmake"
        TLS_VERIFY ON)
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

conan_cmake_autodetect(conan_settings)

conan_cmake_install(
    PATH_OR_REFERENCE ${CMAKE_SOURCE_DIR}
    BUILD missing
    REMOTE conancenter
    SETTINGS ${conan_settings}
)

find_package(fmt 8.1.1 REQUIRED)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

add_subdirectory(source)

include(GNUInstallDirs)
