import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    id: root

    property alias text: itemText.text

    width: ListView.view.width
    height: 48

    clip: true

    BasicText {
        id: itemText

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea

        property int currentMouseX
        property int currentMouseY

        anchors.fill: parent
        hoverEnabled: true
        opacity: parent.containsMouse ? 1 : 0.7
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

