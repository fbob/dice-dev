import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.3

Item {
    id: root

    property var undoAction: Action {
        id: undoAction
        text: "Undo"
        shortcut: "Ctrl+Z"
        onTriggered: {
            webEngineView.runJavaScript("editor.undo()")
        }
        enabled: webEngineView.focus
        tooltip: text
        iconSource: "images/leftanglearrow.svg"
        iconName: text
    }
    property var redoAction: Action {
        id: redoAction
        text: "Redo"
        shortcut: "Ctrl+Y"
        onTriggered: {
            webEngineView.runJavaScript("editor.redo()")
        }
        enabled: webEngineView.focus
        tooltip: text
        iconSource: "images/rightanglearrow.svg"
        iconName: text
    }
    property var saveFileAction: Action {
        id: saveFile
        text: "Save"
        shortcut: "Ctrl+S"
        onTriggered: {
            saveFileInIDE()
        }
        enabled: webEngineView.focus && appWindow.helpPath !== ""
        tooltip: "Save File"
        iconSource: "images/save.svg"
        iconName: text
    }
}
