project(build)
cmake_minimum_required(VERSION 2.8)


SET(CMAKE_CXX_FLAGS "-std=c++11 -fPIC")
set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt5Widgets REQUIRED)
find_package(Qt5Gui REQUIRED)
find_package(Qt5Core REQUIRED)

# # needs to be set before VTK, otherwise python 2 is used
# find_package(PythonLibs 3.3 REQUIRED)
# include_directories(${PYTHON_INCLUDE_DIR})

find_package(VTK 6.1 REQUIRED)
include(${VTK_USE_FILE})

include_directories(qtquick2applicationviewer)
include_directories("../project")
qt5_add_resources(dice_rcc "../dice.qrc" "../qml/DICE/resources.qrc")

set(SRC "fileloader.cpp" "directorydialog.cpp")
add_executable(DICE ${dice_rcc} "main.cpp" ${SRC} "../qtquick2applicationviewer/qtquick2applicationviewer.cpp")

qt5_use_modules(DICE Widgets Qml Quick)
target_link_libraries(DICE project)

set_target_properties(DICE PROPERTIES 
  EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}"
)

SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})


 
# find_package(PythonLibs 3.3 REQUIRED)
# include_directories(${Boost_INCLUDE_DIRS})
# 
# FIND_PACKAGE(Boost)
# FIND_PACKAGE(Boost COMPONENTS python-py33) # Ubuntu package
# 
# if(Boost_FOUND)
#   # found, nothing to do
# else()
#   FIND_PACKAGE(Boost COMPONENTS python3 REQUIRED) # Arch package
# endif()
# 
# include_directories(build)
# 
# file(GLOB_RECURSE project_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/project
# #     "project/*.h"
#     "*.cpp"
# )
#  
# add_library(project SHARED ${project_SRC})
#   
# qt5_use_modules(project Core Gui Quick)
# target_link_libraries(project  ${PYTHON_LIBRARIES} ${Boost_LIBRARIES} ${VTK_LIBRARIES})

# file(COPY "python" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
# 
# file(COPY "test/python/" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/python_tests")
# add_custom_target(test COMMAND nosetests3 DEPENDS project)
# 
