cmake_minimum_required(VERSION 3.3)
project(Box2D)

if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 11)
endif()

FILE(GLOB_RECURSE all_h Box2D/Box2D/*.h)
FILE(GLOB_RECURSE all_h_rel
    RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/Box2D"
    Box2D/Box2D/*.h)
FILE(GLOB_RECURSE all_cpp Box2D/Box2D/*.cpp)

add_library(Box2D STATIC ${all_h} ${all_cpp})

target_include_directories(Box2D PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Box2D>
    $<INSTALL_INTERFACE:include>)

target_compile_definitions(Box2D PRIVATE
    $<IF:$<CONFIG:Debug>,DEBUG,NDEBUG>)

install(TARGETS Box2D EXPORT Box2D-targets DESTINATION lib)

install(EXPORT Box2D-targets
    FILE Box2D-config.cmake
    NAMESPACE Box2D::
    DESTINATION lib/cmake/Box2D)

foreach(h ${all_h_rel})
    get_filename_component(d "${h}" DIRECTORY)
    install(FILES "Box2D/${h}" DESTINATION "include/${d}")
endforeach()
