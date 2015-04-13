import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.Components 1.0
import DICE.Theme 1.0

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 20
    color: colors.mainBackgroundColor

    RectShadow {}
    Rectangle { anchors.fill: parent; color: colors.mainBackgroundColor }

    Row {
        spacing: 2
        anchors.left: parent.left
        width: parent.width
        height: parent.height

        Item {
            height: parent.height
            width: 30
            FontAwesomeIcon {
                id: consoleIcon
                name: "Terminal"
                size: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        BasicText {
            width: 100
            text: "Console"
            anchors.verticalCenter: parent.verticalCenter
        }
        Rectangle {
            color: "#666"
            width: 1
            height: parent.height-6
            anchors.verticalCenter: parent.verticalCenter
        }
        FlatButton {
            width: 50
            text: "clear"
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            onClicked: globalConsole.text = ""
        }
        Item {
            height: parent.height
            width: parent.width - 250
        }
        Item {
            height: parent.height
            width: 30
            FontAwesomeIcon {
                id: maximizeConsoleIcon
                name: "AngleUp"
                size: 18
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    maximizeConsoleIcon.opacity = 0.5
                }
                onExited: {
                    maximizeConsoleIcon.opacity = 1
                }
                onClicked: consoleWindow.height = mainSplitView.height - 100
            }
             visible: consoleWindow.height != mainSplitView.height - 100
        }
        Item {
            height: parent.height
            width: 30

            FontAwesomeIcon {
                id: minimizeConsoleIcon
                icon: FontAwesome.Icon.AngleDown
                color: "#333"
                size: 18
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    minimizeConsoleIcon.opacity = 0.5
                }
                onExited: {
                    minimizeConsoleIcon.opacity = 1
                }
                onClicked: consoleWindow.height = 150
            }
             visible: consoleWindow.height === mainSplitView.height - 100
        }
        Item {
            height: parent.height
            width: 30

            Image {
                id: closeConsoleIcon
                source: "images/close.svg"
                sourceSize.height: 12
                sourceSize.width: 12
                opacity: 1
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    closeConsoleIcon.opacity = 0.5
                }
                onExited: {
                    closeConsoleIcon.opacity = 1
                }
                onClicked: bottomControls.expandConsole()
            }
        }
    }
}
