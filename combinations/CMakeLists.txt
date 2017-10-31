cmake_minimum_required(VERSION 3.1)
project(hhcombinations)

add_library(combinations INTERFACE)
target_include_directories(combinations
    INTERFACE
        $<INSTALL_INTERFACE:include>)

install(TARGETS combinations EXPORT targets)
install(EXPORT targets DESTINATION lib/cmake/hhcombinations
        NAMESPACE hh:: FILE hhcombinations-config.cmake)
install(FILES combinations.h DESTINATION include/hh)
