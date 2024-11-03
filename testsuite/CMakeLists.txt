cmake_minimum_required(VERSION 3.28)

set(PROJECT_UNIT_TESTS_NAME ${CMAKE_PROJECT_NAME}_unit_tests)

project(${PROJECT_UNIT_TESTS_NAME} LANGUAGES CXX VERSION 0.0.1)

include(Catch)

add_executable(${PROJECT_UNIT_TESTS_NAME} test_me.cpp)

target_include_directories(${PROJECT_UNIT_TESTS_NAME} PRIVATE
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src>
)

target_link_libraries(${PROJECT_UNIT_TESTS_NAME} PRIVATE Catch2::Catch2WithMain)

enable_testing()

catch_discover_tests(${PROJECT_UNIT_TESTS_NAME}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)
