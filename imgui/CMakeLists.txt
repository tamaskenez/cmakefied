cmake_minimum_required(VERSION 3.3)
project(imgui)

find_package(glfw3)
find_package(OpenGL)
find_package(glew CONFIG)

set(root ${CMAKE_CURRENT_SOURCE_DIR})
set(phdrs ${root}/imgui.h)
set(hdrs ${root}/imstb_rectpack.h ${root}/imstb_textedit.h ${root}/imstb_truetype.h
    ${root}/imgui_internal.h)
set(srcs ${root}/imgui.cpp
    ${root}/imgui_demo.cpp ${root}/imgui_draw.cpp ${root}/imgui_widgets.cpp
    ${root}/imgui_tables.cpp)

add_library(imgui STATIC ${phdrs} ${hdrs} ${srcs})
target_include_directories(imgui PUBLIC
    $<BUILD_INTERFACE:${root}>
    $<INSTALL_INTERFACE:include>)
target_compile_definitions(
    imgui PUBLIC IMGUI_DISABLE_INCLUDE_IMCONFIG_H
    $<$<BOOL:${IMGUI_DISABLE_OBSOLETE_FUNCTIONS}>:IMGUI_DISABLE_OBSOLETE_FUNCTIONS>)
set_target_properties(imgui PROPERTIES DEBUG_POSTFIX "d")

set(targets imgui)
set(headers_to_install ${phdrs})

if(glfw3_FOUND AND OPENGL_FOUND AND glew_FOUND)
    message(STATUS "OpenGL, GLEW and GLFW found, installing imgui::glfw-gl3-glew.")

    # replace #include gl3w.h with glew.h
    file(STRINGS examples/example_glfw_opengl3/main.cpp cppcontent)
    set(cppcontent-glew "")
    foreach(l ${cppcontent})
        if(l MATCHES "#include.*GL/gl3w.h")
            set(l "#include \"GL/glew.h\"")
        endif()
        string(APPEND cppcontent-glew "${l}\n")
    endforeach()
    set(modified_cpp "${CMAKE_CURRENT_BINARY_DIR}/imgui_impl_glfw_gl3-glew.cpp")
    file(WRITE "${modified_cpp}" "${cppcontent-glew}")

    add_library(glfw-gl3-glew STATIC
        "${modified_cpp}"
        backends/imgui_impl_opengl3.h
        backends/imgui_impl_glfw.h
    )
    target_include_directories(glfw-gl3-glew PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/backends>
        $<INSTALL_INTERFACE:include>)
    target_link_libraries(glfw-gl3-glew PUBLIC OpenGL::GL GLEW::glew_s glfw imgui)
    list(APPEND targets glfw-gl3-glew)
    list(APPEND headers_to_install backends/imgui_impl_opengl3.h)
    list(APPEND headers_to_install backends/imgui_impl_glfw.h)
else()
    if(NOT OPENGL_FOUND)
        message(STATUS "OpenGL not found, not installing imgui::glfw-gl3-glew.")
    endif()
    if(NOT glew_FOUND)
        message(STATUS "GLEW not found, not installing imgui::glfw-gl3-glew.")
    endif()
    if(NOT glfw3_FOUND)
        message(STATUS "GLFW not found, not installing imgui::glfw-gl3-glew.")
    endif()

endif()

install(TARGETS ${targets}
    EXPORT imgui-targets DESTINATION lib)
install(EXPORT imgui-targets
    FILE imgui-config.cmake
    NAMESPACE imgui::
    DESTINATION lib/cmake/imgui)
install(FILES ${headers_to_install}
    DESTINATION include)
