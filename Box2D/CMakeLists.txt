cmake_minimum_required(VERSION 3.3)
project(Box2D)

if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 11)
endif()

FILE(GLOB_RECURSE all_h Box2D/Box2D/*.h)
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

set(phdrs
    "Box2D/Box2D.h"
    "Box2D/Common/b2Settings.h"
    "Box2D/Common/b2Draw.h"
    "Box2D/Common/b2Timer.h"
    "Box2D/Collision/Shapes/b2CircleShape.h"
    "Box2D/Collision/Shapes/b2EdgeShape.h"
    "Box2D/Collision/Shapes/b2ChainShape.h"
    "Box2D/Collision/Shapes/b2PolygonShape.h"
    "Box2D/Collision/b2BroadPhase.h"
    "Box2D/Collision/b2Distance.h"
    "Box2D/Collision/b2DynamicTree.h"
    "Box2D/Collision/b2TimeOfImpact.h"
    "Box2D/Dynamics/b2Body.h"
    "Box2D/Dynamics/b2Fixture.h"
    "Box2D/Dynamics/b2WorldCallbacks.h"
    "Box2D/Dynamics/b2TimeStep.h"
    "Box2D/Dynamics/b2World.h"
    "Box2D/Dynamics/Contacts/b2Contact.h"
    "Box2D/Dynamics/Joints/b2DistanceJoint.h"
    "Box2D/Dynamics/Joints/b2FrictionJoint.h"
    "Box2D/Dynamics/Joints/b2GearJoint.h"
    "Box2D/Dynamics/Joints/b2MotorJoint.h"
    "Box2D/Dynamics/Joints/b2MouseJoint.h"
    "Box2D/Dynamics/Joints/b2PrismaticJoint.h"
    "Box2D/Dynamics/Joints/b2PulleyJoint.h"
    "Box2D/Dynamics/Joints/b2RevoluteJoint.h"
    "Box2D/Dynamics/Joints/b2RopeJoint.h"
    "Box2D/Dynamics/Joints/b2WeldJoint.h"
    "Box2D/Dynamics/Joints/b2WheelJoint.h"
)

foreach(h ${phdrs})
    get_filename_component(d "${h}" DIRECTORY)
    install(FILES "Box2D/${h}" DESTINATION "include/${d}")
endforeach()
