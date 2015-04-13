import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    id: root
    property bool isCurrent: ListView.isCurrentItem
    property bool option: sectionClass === "opt"

    width: ListView.view.width
    height: Math.max(50, buttonLabel.height + 20)
    clip: true

    onIsCurrentChanged: {
        isCurrent ? state = "ACTIVE" : state = "NORMAL";
    }

    Component.onCompleted: {
        isCurrent ? state = "ACTIVE" : state = "NORMAL"
    }

    // Background for Items
    Rectangle {
        id: background

        color: "#fff"
        width:parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.right: parent.right

        RightBorder {
            color: colors.borderColor
        }

        LeftBorder {
            color: colors.highlightColor
            anchors.leftMargin: 1
            width: 2
            visible: isCurrent
        }
    }

    // Label
    Item {
        id: label

        anchors {
            left: parent.left
            top: parent.top
            right: icon.left
            bottom: parent.bottom
        }
        implicitHeight: col.height
        height: implicitHeight
        width: buttonLabel.width + 20

        Rectangle {
            width: 20
            height: 20
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            color: "#fff"
            border.width: 1
            border.color: colors.borderColor
            radius: 4
            opacity: 0.8

            BasicText {
                text: listItem.charAt(0)
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#515151"
                font.family: fonts.mainFont
                font.pixelSize: 10
            }
        }

        Column {
            id: col

            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            ButtonText {
                id: buttonLabel
                width: root.width - 60
                verticalAlignment: Text.AlignVCenter
                anchors {
                    left: parent.left
                    leftMargin: 40
                    rightMargin: 10
                }
                text: listItem
                font.bold: isCurrent
                font.family: isCurrent ? fonts.mainFontBold : fonts.mainFont
            }
        }
    }

    // Right Arrow
    FontAwesomeIcon {
        id: icon
        name: "AngleDoubleright"
        color: "black"
        size: 9
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16
        visible: !isCurrent && !option
    }

    // Options Icon
    FontAwesomeIcon {
        id: optionsIcon
        name: "Cog"
        color: "#515151"
        size: 9
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16
        visible: !isCurrent && option
    }

    BottomBorder{ color: colors.borderColor; visible: isCurrent }
    TopBorder{ color: colors.borderColor; visible: isCurrent }
    LeftBorder{ color: colors.borderColor }

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
            parent.forceActiveFocus()
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
    }

    states: [
        State {
            name: "NORMAL"
            PropertyChanges { target: background; color: option ? "#e0e0e0" : "#fff" }
            PropertyChanges { target: buttonLabel; color: option ? "#515151" :"#666" }
            PropertyChanges { target: icon; color: "black" }
            PropertyChanges { target: optionsIcon; color: "#515151" }
        },
        State {
            name: "HOVER"
            PropertyChanges { target: background; color: "#4EA6EA" }
            PropertyChanges { target: buttonLabel; color: "white" }
            PropertyChanges { target: icon; color: "white" }
            PropertyChanges { target: optionsIcon; color: "white" }
        },
        State {
            name: "ACTIVE"
            PropertyChanges { target: background; color: "#f4f4f4" }
        }
    ]

    transitions: [
        Transition {
            from: "NORMAL"; to: "HOVER"
                 ColorAnimation {target: background; properties: "color"; duration: 300 }
                 ColorAnimation {target: buttonLabel; properties: "color"; duration: 100 }
                 ColorAnimation {target: icon; properties: "color"; duration: 100 }
                 ColorAnimation {target: optionsIcon; properties: "color"; duration: 100 }
        }
    ]

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
