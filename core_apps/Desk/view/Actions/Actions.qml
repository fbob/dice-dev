import QtQuick 2.4
import QtQuick.Controls 1.3

Item {
    id: root

    property var createConnectorAction: createConnectorAction
    property var deleteConnectorAction: deleteConnectorAction
    property var deleteStreamItemFromWorkSpaceAction: deleteStreamItemFromWorkSpaceAction
    property var renameStreamItemAction: renameStreamItemAction
    property var runSelectedStreamItem: runSelectedStreamItem
    property var cloneSelectedStreamItem: cloneSelectedStreamItem
    property var killCurrentRunningSelectedStreamItem: killCurrentRunningSelectedStreamItem

    // Connections
    // -----------
    Action {
        id: createConnectorAction
        text: "Create Connector"
        shortcut: ""
        iconSource: "../images/startCreatingConnection.svg"
        onTriggered: desk.workSpace.startCreatingConnection()
    }
    Action {
        id: deleteConnectorAction
        text: "Delete Connector"
        shortcut: StandardKey.Delete
        iconSource: "../images/deleteConnector.svg"
        enabled: !!deskData.currentFocusedConnector
        onTriggered: {
            deskData.removeCurrentConnector()
        }
    }


    // StreamItems
    // -----------
    DeleteStreamItemConfirmation { id: deleteConfirm }
    DeleteStreamItemDialog { id: deleteStreamItemDialog }
    Action {
        id: deleteStreamItemFromWorkSpaceAction
        text: "Delete StreamItem"
        shortcut: StandardKey.Delete
        iconSource: "../images/deleteStreamItemFromWorkSpace.svg"
        enabled: !!deskData.currentFocusedStreamItem && deskData.currentFocusedStreamItem.focus
        onTriggered: {
            deleteStreamItemDialog.open()
        }
    }
    Action {
        id: renameStreamItemAction
        text: "Rename StreamItem"
        shortcut: "F2"
        iconSource: "../images/renameStreamItem.svg"
        enabled: !!deskData.currentFocusedStreamItem && deskData.currentFocusedStreamItem.focus
        onTriggered: {
            desk.workSpace.editStreamItem(deskData.currentFocusedStreamItem)
        }
    }

    Action {
        id: runSelectedStreamItem
        text: "Run StreamItem"
        iconSource: "../Menus/images/playArrow.svg"
        enabled: !!deskData.currentFocusedStreamItem && deskData.currentFocusedStreamItem.focus
        onTriggered: {
            dice.project.scheduleRun(deskData.currentFocusedStreamItem.app)
        }
    }

    Action {
        id: killCurrentRunningSelectedStreamItem
        text: "Kill current running StreamItem"
        iconSource: "../Menus/images/killRun.svg"
        enabled: !!deskData.currentFocusedStreamItem && deskData.currentFocusedStreamItem.focus &&
                 deskData.currentFocusedStreamItem.app.status === "running"
        onTriggered: {
            deskData.currentFocusedStreamItem.app.killProc()
        }
    }

    Action {
        id: cloneSelectedStreamItem
        text: "Clone StreamItem"
        iconSource: "../Menus/images/playArrow.svg"
        shortcut: "Ctrl+C,Ctrl+V"
        enabled: !!deskData.currentFocusedStreamItem && deskData.currentFocusedStreamItem.focus
        onTriggered: {
            dice.desk.cloneStreamItem(deskData.currentFocusedStreamItem.app)
        }
    }
}
