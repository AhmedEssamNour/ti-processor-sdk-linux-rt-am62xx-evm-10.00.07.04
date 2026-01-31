cmake_minimum_required(VERSION 3.22.1)

project(cunit C CXX)

add_executable(cunit_app)

target_sources(cunit_app
    PRIVATE
        main.c
        ${CMAKE_CURRENT_SOURCE_DIR}/testsuite1/src/testsuite1.c
)

target_include_directories(cunit_app
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/testsuite1/include
)

target_compile_features(cunit_app
    PRIVATE
        c_std_23
        cxx_std_23
)

target_compile_options(cunit_app
    PRIVATE
        $<$<COMPILE_LANGUAGE:C>:-Wall -Wextra -Werror>
        $<$<COMPILE_LANGUAGE:CXX>:-Wall -Wextra -Wno-exceptions>
)