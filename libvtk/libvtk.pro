TEMPLATE = lib
TARGET = ../libview/DICE/App/Renderer/vtk
QT += qml quick
CONFIG += qt plugin c++11

TARGET = $$qtLibraryTarget($$TARGET)
uri = DICE.App.Renderer

INCLUDEPATH += src
QMAKE_RPATHDIR += /usr/local/lib

# Input
SOURCES += \
    vtk_plugin.cpp \
    src/loader/stlloader.cpp \
    src/loader/loaderbase.cpp \
    src/fborenderitem.cpp \
    src/vtkqfborenderer.cpp \
    src/vtkqopenglrenderwindow.cpp \
    src/vtkqmlrenderwindowinteractor.cpp \
    src/loader/openfoamloader.cpp \
    src/geometries/pointgeometry.cpp \
    src/geometries/geometrybase.cpp \
    src/geometries/boxgeometry.cpp \
    src/geometries/multipatchboxgeometry.cpp \
    src/vtkqmlinteractorstyleswitch.cpp \
    src/helper/camerahelper.cpp \
    src/geometries/cylindergeometry.cpp \
    src/geometries/conegeometry.cpp \
    src/geometries/planegeometry.cpp \
    src/geometries/spheregeometry.cpp \
    src/geometries/linegeometry.cpp \
    src/geometries/diskgeometry.cpp \
    src/geometries/tubegeometry.cpp \
    src/geometries/cone2Rgeometry.cpp

HEADERS += \
    vtk_plugin.h \
    src/loader/stlloader.h \
    src/loader/loaderbase.h \
    src/fborenderitem.h \
    src/vtkqfborenderer.h \
    src/vtkqopenglrenderwindow.h \
    src/vtkqmlrenderwindowinteractor.h \
    src/loader/openfoamloader.h \
    src/geometries/pointgeometry.h \
    src/geometries/geometrybase.h \
    src/geometries/boxgeometry.h \
    src/geometries/multipatchboxgeometry.h \
    src/vtkqmlinteractorstyleswitch.h \
    src/helper/camerahelper.h \
    src/geometries/cylindergeometry.h \
    src/geometries/conegeometry.h \
    src/geometries/planegeometry.h \
    src/geometries/spheregeometry.h \
    src/geometries/linegeometry.h \
    src/geometries/diskgeometry.h \
    src/geometries/tubegeometry.h \
    src/geometries/cone2Rgeometry.h

OTHER_FILES += Renderer/Renderer.qml \
                Renderer/qmldir

# install the Renderer into libview
copydata.commands = $(COPY_DIR) $$PWD/Renderer $$OUT_PWD/../libview/DICE/App
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata

unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target
#qmldir
}

include(vtk.pri)

#QMAKE_CXXFLAGS+="-fsanitize=address -fno-omit-frame-pointer"
#QMAKE_CFLAGS+="-fsanitize=address -fno-omit-frame-pointer"
#QMAKE_LFLAGS+="-fsanitize=address"
