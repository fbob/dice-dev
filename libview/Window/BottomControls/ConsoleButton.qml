import QtQuick 2.4
import QtQuick.Layouts 1.1

import DICE.Theme 1.0

Rectangle {
    property bool newContent

    width: 150

    anchors.top: parent.top
    anchors.topMargin: 5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

    color: consoleExpanded ? "#fff" : "#F2F2F0"
    border.width: 1
    border.color: consoleExpanded ? colors.highlightColor : Qt.darker(colors.borderColor, 1.2)

    clip: true

    RowLayout {
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Item {
            width: 25
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 0

            BasicText {
                text: "1"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.family: fonts.codeTextFont
            }

            Rectangle {
                anchors.right: parent.right
                width:1
                height: parent.height
                color: consoleExpanded ? colors.highlightColor : Qt.darker(colors.borderColor, 1.2)
            }
        }

        Item {
            Layout.fillWidth: true
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            BasicText {
                id: consoleButton

                text: "Console"
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                anchors.leftMargin: 10
                font.family: fonts.codeTextFont
            }

            Rectangle {
                anchors.right: parent.right
                height: parent.height
                width: 10
                color: newContent ? colors.highlightColor : "transparent"
            }
        }
    }


    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            bottomControls.expandConsole()
            bottomControls.forceActiveFocus()
        }
        onEntered: {
            cursorShape = Qt.PointingHandCursor
        }
        onExited: {
            cursorShape = Qt.ArrowCursor
        }
    }
}
