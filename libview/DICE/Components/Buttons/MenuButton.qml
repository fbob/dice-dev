import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.Theme 1.0

Item {
    id: root

    property alias mouse: mouse
    property alias icon: icon.name
    property alias imageSource: image.source
    property color gridColor: colors.menuButtonGridColor
    property Menu menu

    signal clicked

    height: parent.height
    width: height

    Rectangle {
        id: fillRect

        anchors.fill: parent
        color: "black"
        opacity: mouse.pressed ? 0.07 :
                                 mouse.containsMouse ? 0.02 : 0.0
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        color: "transparent"
        border.color: gridColor
        opacity: fillRect.opacity * 10
    }

    Item {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        FontAwesomeIcon {
            id: icon

            name: "Reorder"
            color: colors.iconColor
            size: 10
            anchors.centerIn: parent
            visible: !image.visible && !!root.menu
        }

        Image {
            id: image

            sourceSize.width: parent.height/3
            sourceSize.height: parent.height/3
            width: parent.height/3
            height: parent.height/3
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: image.status === Image.Ready
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        cursorShape: "PointingHandCursor"
        onClicked: {
            root.clicked()
            menu.__xOffset = -mouse.x
            menu.__yOffset = -mouse.y+parent.height
            menu.popup()
        }
        hoverEnabled: true
        visible: root.menu
    }
}
