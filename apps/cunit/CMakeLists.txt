cmake_minimum_required(VERSION 3.22.1)

project(cunit C CXX)

add_executable(cunit_app)

# ============================================================
# CUnit third-party location
# ============================================================
set(CUNIT_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/cunit")

target_sources(cunit_app
    PRIVATE
        main.c
        ${CMAKE_CURRENT_SOURCE_DIR}/testsuite1/src/testsuite1.c
)

target_include_directories(cunit_app
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/testsuite1/include
        ${CUNIT_ROOT}/include
)

target_link_libraries(cunit_app
    PRIVATE
        ${CUNIT_ROOT}/lib64/libcunit.a
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