import QtQuick 2.4
import QtGraphicalEffects 1.0

import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Button {
    id: root

    property color color: '#EEFF41'

    width: parent.width*0.8
    height: parent.width*0.8
    anchors.centerIn: parent
    text: ""

    style: ButtonStyle {
        background:   Rectangle {
            id: baserect

            property bool down: control.pressed || (control.checkable && control.checked)

            color: "transparent"
            radius: width/2
            anchors.fill: parent
            border.color: control.activeFocus ? "#47b" : "#999"

            Item {
                id: button

                width: buttonContent.width + buttonShadow.radius * 2
                height: buttonContent.height + buttonShadow.radius * 2
                visible: false
                anchors.centerIn: parent

                Rectangle {
                    id: buttonContent

                    width: baserect.width
                    height: baserect.height
                    color: root.color
                    radius: width/2
                    anchors.centerIn: parent
                    anchors.margins: 3
                }

                Image {
                    id: icon

                    source: control.iconSource
                    sourceSize.width: baserect.width
                    sourceSize.height: baserect.height
                    anchors.centerIn: parent
                    opacity: 1
                    Behavior on opacity {
                        NumberAnimation {easing.type: Easing.InOutQuad; duration: 200 }
                    }
                    antialiasing: true
                }
            }

            DropShadow {
                id: buttonShadow

                anchors.fill: source
                cached: true
                radius: 8.0
                samples: 16
                color: "#80000000"
                smooth: false
                source: button
                opacity: down ? 0.8 : 1
                Behavior on opacity {
                       NumberAnimation {easing.type: Easing.InOutQuad; duration: 200 }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: control.activeFocus ? "#47b" : "#000"
                opacity: control.hovered || control.activeFocus ? 0.1 : 0
                Behavior on opacity {NumberAnimation{ duration: 100 }}
            }

            Rectangle {
                anchors.fill: parent
                color: "#000"
                opacity: down ? 0.2 : 0
                radius: parent.radius
                Behavior on opacity {
                       NumberAnimation {easing.type: Easing.InOutQuad; duration: 100 }
                }
            }
        }
        label: Item {}
    }
}
