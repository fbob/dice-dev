import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.3

Item {
    id: root

    NewProjectDialog { id: newProjectDialog }

    FileDialog {
        id: projectOpenDialog

        property var acceptedCallback

        nameFilters: ["DICE project (*.dice)"]
        onAccepted: acceptedCallback(fileUrl.toString().substring(7)) // remove "file://" from the url

        function openUrl(callback) {
            acceptedCallback = callback
            open()
        }
    }

    Connections {
        target: dice
        onProjectChanged: {
            mainNavi.gotoCoreApp("Desk")
        }
    }

    property var createNewProjectAction: Action {
        id: createNewProjectAction
        text: "New Project"
        shortcut: "Ctrl+N"
        onTriggered: {
            leftOptionsSideBar.content = newProjectDialog
            leftOptionsSideBar.open()
        }
        tooltip: text
        iconSource: "../images/create_new_project.svg"
        iconName: text
    }

    property var loadProjectAction: Action {
        id: loadProjectAction
        text: "Load Project"
        shortcut: "Ctrl+L"
        onTriggered: projectOpenDialog.openUrl(dice.loadProject)
        tooltip: text
        iconSource: "../images/load_project.svg"
        iconName: text
    }


    property var closeProject: Action {
        id: closeProjectAction
        text: "Close Project"
        shortcut: ""
        tooltip: text
        iconSource: "../images/close_project.svg"
        enabled: dice.project.loaded
        onTriggered: {
            coreApp.closeProject()
        }
        iconName: text
    }

    property var openDiceSettingsAction: Action {
        id: openDiceSettingsAction
        text: "Open Dice Settings"
        shortcut: ""
        onTriggered: mainNavi.gotoCoreApp("Settings")
        tooltip: text
        iconSource: "../images/settings.svg"
        iconName: text
    }

    property var openHelpAction: Action {
        id: openHelpAction
        text: "Open Dice Help"
        shortcut: ""
        onTriggered: mainNavi.gotoCoreApp("Help")
        tooltip: text
        iconSource: "../images/help.svg"
        iconName: text
    }
}
