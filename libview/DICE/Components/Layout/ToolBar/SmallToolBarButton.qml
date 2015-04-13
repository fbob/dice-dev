import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import QtQuick.Controls.Private 1.0
import DICE.Theme 1.0

Button {
    id: root

    property var iconFontName
    property bool centerLeft
    property color iconFontColor: "#3B8DBD"

    property Component overlayContent

    onClicked: {
        if (!!overlayContent) {
            overlayRectangle.overlayContent = overlayContent
            overlayRectangle.visible = true
        }
    }

    enabled: action.enabled

    onEnabledChanged: {
        if (!enabled)
            opacity = 0.5
        else
            opacity = 1.0
    }

    style: ButtonStyle {
        background: Item {

            implicitWidth: Math.round(TextSingleton.implicitHeight * 4.5)
            implicitHeight: Math.max(25, Math.round(TextSingleton.implicitHeight * 1.2))

            Rectangle {
                anchors.fill: parent
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
                radius: 2
                anchors.fill: parent
                border.color: control.activeFocus ? "#47b" : "#999"

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: control.activeFocus ? "#47b" : "white"
                    opacity: control.hovered || control.activeFocus ? 0.1 : 0
                    Behavior on opacity {NumberAnimation{ duration: 100 }}
                }
                opacity: control.hovered || control.pressed ? 0.2 : 0
            }

            clip: true

            Rectangle {
                id: highlightRect

                property int radiusParameter: 10

                opacity: 0
                color: "#f2f2f2"
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
                id: imageItem

                visible: control.menu !== null
                source: "../images/arrow-down.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: padding.right
                opacity: control.enabled ? 0.6 : 0.5
            }
        }

        label: Item {
            implicitWidth: control.menu !== null ? row.implicitWidth + 25 : row.implicitWidth //+ 25 // +25 for imageItem-Arrow
            implicitHeight: 18 //row.implicitHeight
            Row {
                id: row

                anchors.left: parent.left
                spacing: 2 //5

                Image {
                    source: control.iconSource
                    anchors.verticalCenter: parent.verticalCenter
                    sourceSize.width: 17
                    sourceSize.height: 17
                    visible: !root.iconFontName
                }

                Item {
                    width: 4
                    height: 1
                }

                BasicText {
                    id: buttonText

                    anchors.verticalCenter: parent.verticalCenter
                    text: control.text
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    wrapMode: TextEdit.WordWrap
                    color: colors.windowToolBarTextColor
                }
            }
        }

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
                anchors.fill: parent
                anchors.leftMargin: padding.left
                anchors.topMargin: padding.top
                anchors.rightMargin: padding.right
                anchors.bottomMargin: padding.bottom
            }
        }

    }
}
