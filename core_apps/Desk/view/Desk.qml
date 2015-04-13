import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import DICE.Components 1.0

import "Actions"
import "Menus"

import "AppsView"
import "WorkSpaceView"
import "StreamItem"

CoreApp {
    id: desk

    title: "Desk"
    toolBar: ToolBar {}

    property alias dummyStreamItem: dummyStreamItem
    property alias workSpace: workSpaceView.workSpace
    property alias workSpaceView: workSpaceView
    property alias appsView: appsView

    anchors.fill: parent

    // Needs alias so it can be called from other core_apps
    property alias deskData: deskData
    DeskData {
        id: deskData
    }

    // Exporting the actions of Home for other CoreApps, e.g. Desk.
    // Always use the exact same two lines.
    Actions { id: actions }
    actions: actions

    RightClickMenu { id: rightClickMenu }

    WorkSpaceBehavior { id: workSpaveBehavior }

    SplitView {
        id: splitView

        property var dragged_app: null

        anchors.fill: parent

        AppsView {
            id: appsView
            Layout.minimumWidth: 150
            width: 300
        }

        WorkSpaceView {
            id: workSpaceView
            Layout.fillWidth: true
            Layout.minimumWidth: 300
        }
    }

    // Dummy for dragging to the workspace
    DummyStreamItem {
        id: dummyStreamItem
    }

    Rectangle {
        // overlay for disabling the desk if no project is opened
        anchors.fill: parent
        opacity: 0.5
        color: "#000"

        visible: !dice.project.loaded

        MouseArea {
            anchors.fill: parent
        }

        FlatButton {
            width: 200
            height: 50
            anchors.centerIn: parent
            text: "Load project"
            color: colors.highlightColor
            textColor: "#fff"
            onClicked: {
                console.log("home: "+mainWindow.getCoreApp("Home").actions.loadProjectAction)
                mainWindow.getCoreApp("Home").actions.loadProjectAction.trigger()
            }
        }
    }
}
