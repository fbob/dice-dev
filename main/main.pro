
TEMPLATE = app

# Add more folders to ship with the application, here

folder_core.source = ../core
folder_core.target = ..
DEPLOYMENTFOLDERS += folder_core

folder_core_apps.source = ../core_apps
folder_core_apps.target = ..
DEPLOYMENTFOLDERS += folder_core_apps

folder_libview.source = ../libview
folder_libview.target = ..
DEPLOYMENTFOLDERS += folder_libview

folder_apps.source = ../apps
folder_apps.target = ..
DEPLOYMENTFOLDERS += folder_apps

folder_db.source = ../db
folder_db.target = ..
DEPLOYMENTFOLDERS += folder_db

folder_test.source = ../test
folder_test.target = ..
DEPLOYMENTFOLDERS += folder_test

QT += qml core opengl webengine
# widgets quick gui
CONFIG += c++11
# Additional import path used to resolve QML modules in Creator´s code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
           pythonloader.cpp

HEADERS += pythonloader.h

# Installation path
# target.path =

include(deployment.pri)
qtcAddDeployment()

DEFINES += QMAKE

#INCLUDEPATH += ../libdice
#LIBS += -L.. -ldice

TARGET = ../DICE

QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''

#OTHER_FILES +=

#RESOURCES +=

#DISTFILES +=

include(../libdice/python.pri)

#QMAKE_CXXFLAGS+="-fsanitize=address -fno-omit-frame-pointer"
#QMAKE_CFLAGS+="-fsanitize=address -fno-omit-frame-pointer"
#QMAKE_LFLAGS+="-fsanitize=address"

DISTFILES += \
    ../apps/OpenFOAM_230/Preprocessing/cartesianMesh2/view/actions/RenameDialog.qml \
    ../libview/DICE/App/Components/Inputs/VectorField2D.qml \
    ../libview/DICE/App/Foam/FoamRadioButtonGroup.qml \
    ../libview/DICE/App/Foam/FoamValue.qml \
    ../core_apps/CodeMirror/view/IDE \
    ../core_apps/IDE/view/IDE.qml \
    ../libview/Material/TextField.qml \
    ../apps/OpenFOAM_230/Preprocessing/cfMesh/view/actions/SurfaceGenerateBoundingBox

