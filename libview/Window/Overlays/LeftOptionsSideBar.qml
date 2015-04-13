import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import DICE.Components 1.0

SplitView {
    id: root

    property int defaultWidth: 320
    property Component content

    signal open
    signal close

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

    property Component emptyComponent: Item {
        id: emptyContent
    }

    onOpen: {
        root.visible = true
        openAnim.running = true
        root.forceActiveFocus()
    }
    onClose: {
        closeAnim.running = true
        content = emptyComponent
    }

    Item {
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
                        iconSource: "images/close.svg"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            root.close()
                        }
                    }
                }
                Item {
                    height: 10
                    width: 1
                }
                PaddedScrollViewRect {
                    id: scrollView

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
            }

            onWidthChanged: {
                if (width == 0)
                    root.visible = false
            }
        }
    }

    // Space filler for the rest of the space (DO NOT DELETE !!!)
    Item {
        Layout.fillWidth: true
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

