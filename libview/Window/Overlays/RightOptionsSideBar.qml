import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtWebEngine 1.0

import DICE.Components 1.0

SplitView {
    id: root

    property int defaultWidth: 320
    property Component content
    property var url
    property string fragment

    signal open
    signal close

    function load(url, fragment) {
        root.url = url
        root.fragment = fragment
        webView.url = url
        mainWindow.getCoreApp("Help").webEngineView.load(url, fragment)
    }

    orientation: Qt.Horizontal
    width: parent.width
    height: {
        if (consoleWindow.visible) {
            appWindow.height - toolBar.height - tabsBar.height - bottomControls.height - consoleWindow.height
        }
        else
            appWindow.height - toolBar.height - tabsBar.height - bottomControls.height
    }
    anchors.top: tabsBar.bottom
    visible: false

    clip: true

    onOpen: {
        if (!root.visible) {
            root.visible = true
            openAnim.running = true
            root.forceActiveFocus()
        }
        if (!!root.url) {
            // do not use reload() here because it doesnt't jump to #id
            webView.url = ""
            webView.url = root.url
        }
    }
    onClose: {
        closeAnim.running = true
    }

    // Space filler for the rest of the space (DO NOT DELETE !!!)
    Item {
        Layout.fillWidth: true
    }

    // Right sidebar
    Rectangle {
        id: sideBar

        width: 0
        height: parent.height

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
        }

        RectShadow {}

        Rectangle {
            anchors.margins: 1
            anchors.fill: parent
            border.width: 1
            border.color: colors.borderColor
            color: colors.mainBackgroundColor
        }

        Rectangle {
            color: "#eee"
            anchors.fill: parent
            anchors.margins: variables.windowPadding
            border.color: colors.borderColor
            border.width: 1

            Rectangle {
                id: mainBackground

                anchors.fill: parent
                color: "#eee"
                opacity: 0.02
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#C0C0C0"; }
                    GradientStop { position: 1.0; color: "#767676"; }
                }
            }

            Column {
                id: column

                height: parent.height
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 1
                anchors.rightMargin: 1

                MainHeader {
                    id: mainHeader

                    FlatButton {
                        id: closeButton

                        text: "Close"
                        width: 110
                        iconSource: "images/closeToRight.svg"
                        onClicked: {
                            root.close()
                        }
                    }
                    FlatButton {
                        awesomeIconName: "Home"
                        onClicked: {
                            root.load(mainWindow.getCoreApp("Help").homeHTMLPath, "")
                        }
                        visible: webView.visible
                    }
                    FlatButton {
                        awesomeIconName: "ArrowLeft"
                        onClicked: {
                            webView.goBack()
                        }
                        visible: webView.visible
                        enabled: webView.canGoBack
                    }
                    FlatButton {
                        awesomeIconName: "ArrowRight"
                        onClicked: {
                            webView.goForward()
                        }
                        visible: webView.visible
                        enabled: webView.canGoForward
                    }
                    FlatButton {
                        awesomeIconName: "Refresh"
                        onClicked: {
                            webView.reload()
                        }
                        visible: webView.visible
                    }
                }
                Item {
                    height: 10
                    width: 1
                }
                PaddedScrollViewRect {
                    id: scrollView

                    visible: !root.url
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: column.height - mainHeader.height - 11
                    contentHeight: contentLoader.height

                    Loader {
                        id: contentLoader

                        anchors.centerIn: parent
                        sourceComponent: root.content
                    }
                }
                // Item for help/documentation
                // ===========================
                Item {
                    visible: !!root.url
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: column.height - mainHeader.height - 11

                    WebEngineView {
                        id: webView

                        focus: true
                        anchors.fill: parent
                        onLoadProgressChanged: {
                            var docsCss = mainWindow.getCoreApp("Help").docsCSS
                            var docsFont = mainWindow.getCoreApp("Help").docsFont
                            runJavaScript(mainWindow.getCoreApp("Help").createJSfunctionForCSSaddidition(docsCss))
                            runJavaScript(mainWindow.getCoreApp("Help").createJSfunctionForCSSaddidition(docsFont))
                            var highlightFragment = "document.getElementById('" + root.fragment + "').style.backgroundColor='oldlace';"
                            runJavaScript(highlightFragment);
                        }
                        onUrlChanged: {
                            if (url !== "")
                                mainWindow.getCoreApp("Help").webEngineView.load(url)
                        }
                    }
                }
            }

            onWidthChanged: {
                if (width == 0)
                    root.visible = false
            }
        }
    }

    SequentialAnimation {
        id: openAnim
        running: false
        NumberAnimation {
            target: sideBar
            property: "width"
            from: 0
            to: defaultWidth
            duration: 300
            easing.type: Easing.InOutQuad
        }
        onRunningChanged: {
            if (!running && !!root.url) {
                webView.url = root.url
            }
        }
    }

    SequentialAnimation {
        id: closeAnim
        running: false
        NumberAnimation {
            target: sideBar
            property: "width"
            from: defaultWidth
            to: 0
            duration: 300
            easing.type: Easing.InOutQuad
        }
        onRunningChanged: {
            if (!running)
                root.visible = false
        }
    }
}

