import QtQuick 2.4
import QtWebEngine 1.0

import DICE.Components 1.0
import DICE.Theme 1.0

import "Menus"
import "Actions"

CoreApp {
    id: root

    property alias webEngineView: webEngineView
    property string homeHTMLPath: coreApp.homeHTMLPath
    property string docsCSS: coreApp.docsCSS
    property string docsFont: coreApp.docsFont


    title: "Help"
    toolBar: ToolBar {}

    // Exporting the actions of Home for other CoreApps, e.g. Desk.
    // Always use the exact same two lines.
    Actions { id: actions }
    actions: actions


    // catch helpPath changes so the full help is not opened when a helpPath is changed and the rightOptionsSideBar is opened
    property bool __helpPathChanged: false
    Connections {
        target: appWindow
        onHelpPathChanged:root.__helpPathChanged = true
    }

    function openHelp() {
        var currentApp = mainWindow.getCoreApp("Desk").deskData.currentApp
        var helpUrl = coreApp.getHelpUrl(currentApp, appWindow.helpPath)
        var helpFragment = coreApp.getHelpFragment(currentApp, appWindow.helpPath)

        if (!rightOptionsSideBar.visible || root.__helpPathChanged) {
            root.__helpPathChanged = false
            rightOptionsSideBar.load(helpUrl, helpFragment)
            rightOptionsSideBar.open()
        } else {
            webEngineView.load(helpUrl, helpFragment)
            root.open()
        }
    }

    onVisibleChanged: {
        // font show the same content twice
        if (root.visible)
            rightOptionsSideBar.close()
    }

    WebEngineView {
        id: webEngineView
        property string fragment

        function load(url, fragment) {
            webEngineView.url = url
            webEngineView.fragment = fragment
        }
        focus: true
        // needs fixed width and height for loading at the start
        // later changed with bindings to fill parent
        width: 500
        height: 500
        url: root.homeHTMLPath

        onLoadingChanged: {
            if (!loading) {
                webEngineView.width = Qt.binding(function() {return root.width})
                webEngineView.height = Qt.binding(function() {return root.height})
            }
        }
        onLoadProgressChanged: {
            runJavaScript(createJSfunctionForCSSaddidition(root.docsCSS))
            runJavaScript(createJSfunctionForCSSaddidition(root.docsFont))
            var highlightFragment = "document.getElementById('" + webEngineView.fragment + "').style.backgroundColor='oldlace';"
            runJavaScript(highlightFragment);
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

    function createJSfunctionForCSSaddidition(css_path) {
            // taken from http://stackoverflow.com/questions/574944/how-to-load-up-css-files-using-javascript
            return  "if (window.location.protocol === 'file:')" +
                    "var cssId = '" + css_path + "';" +
                    "if (!document.getElementById(cssId))
                    {
                        var head  = document.getElementsByTagName('head')[0];
                        var link  = document.createElement('link');
                        link.id   = cssId;
                        link.rel  = 'stylesheet';
                        link.type = 'text/css';
                        link.href = cssId;
                        link.media = 'all';
                        head.appendChild(link);
                    }"
    }
}
