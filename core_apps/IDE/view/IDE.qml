import QtQuick 2.4
import QtWebEngine 1.0

import DICE.Components 1.0
import DICE.Theme 1.0

import "Menus"
import "Actions"

CoreApp {
    id: root

    property alias webEngineView: webEngineView
    property string editorHTMLPath: coreApp.editorHTMLPath
    property string editorData: coreApp.editorData
    property var currentEditedApp

    title: "IDE"
    toolBar: ToolBar { id: toolBar }

    // Exporting the actions of Home for other CoreApps, e.g. Desk.
    // Always use the exact same two lines.
    Actions { id: actions }
    actions: actions


    // catch helpPath changes so the full help is not opened when a helpPath is changed and the rightOptionsSideBar is opened
    property bool __helpPathChanged: false
    Connections {
        target: appWindow
        onHelpPathChanged: root.__helpPathChanged = true
    }

    function openIDE() {
        var currentApp = mainWindow.getCoreApp("Desk").deskData.currentApp
        currentEditedApp = currentApp
        coreApp.getDataByUrl(currentApp, appWindow.helpPath)
        webEngineView.load(editorHTMLPath)
        root.open()
    }

    function saveFileInIDE() {
        var currentApp = mainWindow.getCoreApp("Desk").deskData.currentApp
        webEngineView.runJavaScript(createJSfunctionForSavingFile(), function(data) {
            coreApp.saveDataByUrl(currentEditedApp, appWindow.helpPath, data)
        })
        currentEditedApp.call("load")
    }

    WebEngineView {
        id: webEngineView
        property string fragment

        function load(url) {
            webEngineView.url = url
        }
        focus: true
        // needs fixed width and height for loading at the start
        // later changed with bindings to fill parent
        width: 500
        height: 500
        url: root.editorHTMLPath

        onLoadingChanged: {
            if (!loading) {
                webEngineView.width = Qt.binding(function() {return root.width})
                webEngineView.height = Qt.binding(function() {return root.height})
            }
        }
        onLoadProgressChanged: {
        }
        onLinkHovered: {
            if (hoveredUrl === "")
                resetStatusText.start()
            else {
                resetStatusText.stop()
                statusText.text = hoveredUrl
            }
        }
    }

    Rectangle {
        id: statusBubble

        property int padding: 8

        color: "oldlace"
        visible: statusText.text !== ""

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: statusText.paintedWidth + padding
        height: statusText.paintedHeight + padding

        Text {
            id: statusText

            anchors.centerIn: statusBubble
            elide: Qt.ElideMiddle

            Timer {
                id: resetStatusText

                interval: 750
                onTriggered: statusText.text = ""
            }
        }
    }

    function createJSfunctionForSavingFile() {
        return "if (document.getElementById('code'))
                {
                    editor.getValue();
                }
                "
    }
}
