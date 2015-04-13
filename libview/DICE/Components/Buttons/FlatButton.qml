import QtQuick 2.4
import QtQuick.Layouts 1.1

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    id: root

    property alias text: buttonText.text
    property alias iconSource: image.source
    property alias awesomeIconName: awesomeIcon.name
    property alias scalablePixelSize: buttonText.scalablePixelSize
    property alias scalableLineHeight: buttonText.scalableLineHeight
    property color gridColor: "#d3d3d3"
    property color color: "#f2f2f2"
    property color textColor: "#000"
    property bool raised: false
    property int zDepth: 1
    property bool pressed: mouseArea.pressed
    property alias maximumLineCount: buttonText.maximumLineCount

    signal clicked

    width: Math.max(buttonText.paintedWidth, 60)
    height: Math.max(buttonText.height*2, 35)
    opacity: enabled ? 1 : 0.5

    Item {
        visible: raised
        anchors.fill: parent
        TopShadow {}
        RectShadow {
            zDepth: root.zDepth
        }
    }

    Rectangle {
        id: background

        anchors.fill: parent
        color: root.color
        radius: 2
    }

    Rectangle {
        id: fillRect

        anchors.fill: parent
        color: "black"
        opacity: mouseArea.pressed ? 0.07 :
        mouseArea.containsMouse ? 0.02 : 0.0
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        color: "transparent"
        border.color: gridColor
        opacity: fillRect.opacity * 10
    }

    Item {
        id: clickAnimation

        anchors.fill: parent
        clip: true

        Rectangle {
            id: highlightRect

            property int radiusParameter: parent.height*2
            property int endRadius: parent.width

            opacity: 0
            color: Qt.rgba(0,0,0,0.1)
            width: radiusParameter
            height: radiusParameter
            radius: radiusParameter/2
            x: mouseArea.currentMouseX - radiusParameter/2
            y: mouseArea.currentMouseY - radiusParameter/2

            PropertyAnimation {
                id: animFill

                target: highlightRect
                property: "radiusParameter"
                running: mouseArea.pressed
                from: highlightRect.endRadius/3
                to: highlightRect.endRadius
                easing.type: Easing.InOutQuad
                duration: 200
            }
            PropertyAnimation {
                id: animOpacity

                target: highlightRect
                property: "opacity"
                running: mouseArea.pressed
                from: 0
                to: 1
                easing.type: Easing.InOutQuad
                duration: 100
            }

            PropertyAnimation {
                id: animEmpty

                target: highlightRect
                property: "radiusParameter"
                to: highlightRect.endRadius*2
                easing.type: Easing.InOutQuad
                duration: 200
            }
            PropertyAnimation {
                id: animHide

                target: highlightRect
                property: "opacity"
                from: 1
                to: 0
                easing.type: Easing.InOutQuad
                duration: 350
            }
        }
    }

    Row {
        id: row

        anchors.fill: parent

        Item {
            id: imageItem

            width: {
                if ((image.status === Image.Ready || awesomeIcon.visible) && !!buttonText.text) {
                    return parent.width*0.3
                }
                else {
                    if (image.status === Image.Ready || awesomeIcon.visible)
                        return parent.width
                }
                return 0
            }
            height: parent.height

            Image {
                id: image

                sourceSize.width: parent.height*0.5
                sourceSize.height: parent.height*0.5
                anchors.centerIn: parent
            }

            FontAwesomeIcon {
                id: awesomeIcon

                size: parent.height*0.3
                anchors.centerIn: parent
                visible: !!name
            }
        }

        Item {
            id: textItem

            width: !!buttonText.text ? parent.width - imageItem.width : 0
            height: parent.height

            ButtonText {
                id: buttonText

                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: image.status === Image.Ready ? Text.AlignLeft : Text.AlignHCenter
                color: root.textColor
                elide: Text.ElideRight
                width: parent.width
                maximumLineCount: 1
            }
        }
    }

    MouseArea {
        id: mouseArea

        property int currentMouseX
        property int currentMouseY

        anchors.fill: parent
        cursorShape: "PointingHandCursor"
        hoverEnabled: true
        onClicked: root.clicked()

        onPressed: {
            currentMouseX = mouse.x
            currentMouseY = mouse.y
        }
        onReleased: {
            animEmpty.start()
            animHide.start()
        }
        onCanceled: {
            animEmpty.start()
            animHide.start()
        }
    }
}


