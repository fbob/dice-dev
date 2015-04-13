import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import QtQuick.Controls.Private 1.0
import DICE.Theme 1.0

ToolButton {
    id: root
    height: parent.height

    property var iconFontName
    property bool centerLeft
    property color iconFontColor: "#3B8DBD"

    enabled: action.enabled

    onEnabledChanged: {
        if (!enabled)
            opacity = 0.5
        else
            opacity = 1.0
    }

    style: ButtonStyle {
        background: Item {

            clip: true

            Rectangle {
                anchors.fill: parent
                anchors.bottomMargin: control.pressed ? 0 : -1
                color: "#CFDAEF"
                radius: baserect.radius
                opacity: control.hovered ? 0.8 : 0
            }

            Rectangle {
                id: baserect

                gradient: Gradient {
                    GradientStop {color: control.pressed ? "#aaa" : "#fefefe" ; position: 0}
                    GradientStop {color: control.pressed ? "#ccc" : "#e3e3e3" ; position: control.pressed ? 0.1: 1}
                }
                radius: TextSingleton.implicitHeight * 0.16
                anchors.fill: parent
                border.color: control.activeFocus ? "#47b" : "#999"
                opacity: control.hovered || control.pressed ? 0.2 : 0

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: control.activeFocus ? "#47b" : "white"
                    opacity: control.hovered || control.activeFocus ? 0.1 : 0
                    Behavior on opacity {NumberAnimation{ duration: 100 }}
                }
            }

            Rectangle {
                id: highlightRect

                property int radiusParameter: 10

                opacity: 0
                color: Qt.rgba(0,0,0,0.1)
                width: radiusParameter
                height: radiusParameter
                radius: 100
                anchors.centerIn: parent

                PropertyAnimation {
                    id: anim1

                    target: highlightRect
                    property: "radiusParameter"
                    running: control.pressed
                    from: 0
                    to: 100
                    easing.type: Easing.InOutQuad
                    alwaysRunToEnd: true
                }
                PropertyAnimation {
                    id: anim2

                    running: root.pressed
                    target: highlightRect
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 500
                    easing.type: Easing.InOutQuad
                    alwaysRunToEnd: true
                }
            }

            Image {
                id: icon
                source: control.iconSource
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height: parent.height * 0.55
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 25; //43
                visible: !root.iconFontName
            }
        }
        label: Rectangle {
            implicitWidth: row.implicitWidth
            implicitHeight: row.implicitHeight
            anchors.bottom: parent.bottom
            color: "transparent"

            Row {
                id: row

                anchors.bottom: parent.bottom
                spacing: 2

                BasicText {
                    id: buttonText

                    anchors.verticalCenter: parent.verticalCenter
                    text: control.text
                    width: Math.max(50,paintedWidth,implicitWidth)
                    height: 10
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1
                    color: colors.windowToolBarTextColor
                }
            }
        }

        /*! \internal */
        panel: Item {
            anchors.fill: parent
            implicitWidth: Math.max(labelLoader.implicitWidth + padding.left + padding.right, backgroundLoader.implicitWidth)
            implicitHeight: Math.max(labelLoader.implicitHeight + padding.top + padding.bottom, backgroundLoader.implicitHeight)

            Loader {
                id: backgroundLoader
                anchors.fill: parent
                sourceComponent: background
            }

            Loader {
                id: labelLoader
                sourceComponent: label
                width: parent.width
                height: parent.height*0.4
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: padding.left
                anchors.topMargin: padding.top
                anchors.rightMargin: padding.right
                anchors.bottomMargin: padding.bottom
            }
        }
    }

}

