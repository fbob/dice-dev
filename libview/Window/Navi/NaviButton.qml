import QtQuick 2.4

import DICE.Theme 1.0

Rectangle {
    id: root

    property bool isCurrent: ListView.isCurrentItem

    width: parent.width
    height: 40
    color: state === "HOVER" ? Qt.rgba(0,0,0,0.03) : "transparent"
    clip: true

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    onIsCurrentChanged: {
        isCurrent ? state = "ACTIVE" : state = "NORMAL";
    }

    Component.onCompleted: {
        isCurrent ? state = "ACTIVE" : state = "NORMAL"
    }

    Image {
        source: image
        sourceSize.width: 13
        sourceSize.height: 13
        anchors.leftMargin: 15
        anchors.bottomMargin: 21
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }

    ButtonText {
        text: name
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        color: !isCurrent ? "#979694" : colors.highlightColor
        font.bold: isCurrent
    }

    MouseArea {
        id: mouseArea

        property int currentMouseX
        property int currentMouseY

        anchors.fill: parent
        hoverEnabled: true
        opacity: parent.containsMouse ? 1 : 0.7
        onEntered: {
            !isCurrent ? parent.state = "HOVER" : parent.state = "ACTIVE";
        }
        onExited: {
            !isCurrent ? parent.state = "NORMAL" : parent.state = "ACTIVE";
        }
        onClicked: {
            navi.currentIndex = index
            mainWindow.hideApp()
            mainWindow.active_window.visible = true
        }
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
        onDoubleClicked: {
            mainNavi.toggleWidthNavi()
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
            duration: 0
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
