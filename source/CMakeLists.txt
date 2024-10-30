project(github-action LANGUAGES CXX)

add_executable(${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME}
    PRIVATE
)

target_sources(${PROJECT_NAME}
    PRIVATE
        main.cpp
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<INSTALL_INTERFACE:include>
    PRIVATE
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
)

add_test(NAME github-action-main
    COMMAND
        ${PROJECT_NAME}
)
