import QtQuick 2.1
import QtQuick.Controls 1.0
import DICE.Components 1.0
import DICE.Theme 1.0


Rectangle {
    width: ListView.view.width
//    width: scrollView.viewport.width
//    height: option ? 40 : 50
    height: index === 0 ? 55 : 50

    property bool isCurrent: leftSideBar.currentIndex === index
    color: "transparent"

    onIsCurrentChanged: {
        isCurrent ? state = "ACTIVE" : state = "NORMAL";
    }

    Component.onCompleted: {
        isCurrent ? state = "ACTIVE" : state = "NORMAL"
    }

    //Background for Items
    Rectangle {
        width:parent.width
        height: parent.height
        color: "transparent"
        anchors.left: parent.left
        anchors.right: parent.right

        TopBorder{
            color: colors.borderColor
            visible: index === 0
        }
        RightBorder{
            color: colors.borderColor
//            visible: !isCurrent
        }
        LeftBorder{
            color: colors.highlightColor
            visible: isCurrent
            anchors.leftMargin: 1
            width: 2
        }
    }

    // Label and Description for main Items
    Item {
        id: labelAndDescription
        anchors.top: parent.top
        anchors.left: parent.left
//        anchors.leftMargin: option ? 20 : 0
        anchors.bottom: parent.bottom
        anchors.right: icon.left
        implicitHeight: col.height
        height: implicitHeight
        width: buttonLabel.width + 20

        Column {
            spacing: 2
            id: col
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: buttonLabel

                FontLoader{
                    id: robotoRegular
                    source: "qrc:DICE/Style/Fonts/roboto/Roboto-Regular.ttf"
                }

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 10
                text: listItem
                color: "#666"
//                font.pointSize: option ? 9 : 11
                font.pixelSize: option ? 11 : 12
                font.family: robotoRegular.name
                antialiasing: true
                font.weight: Font.Normal
                lineHeight: 22 //19
                lineHeightMode: Text.FixedHeight
                styleColor: "white"
                visible: index !== 0
            }
//            Text {
//                id: buttonDescription
//                anchors.left: parent.left
//                anchors.margins: 20
//                text: description
//                color: "#666"
////                font.pointSize: 7
//                font.pixelSize: 8
//            }

            MainHeader{
                id: mainHeader
                text: listItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                visible: index === 0
            }
        }
    }

    FontAwesomeIcon {
        id: icon
        icon: FontAwesome.Icon.AngleDoubleRight
        color: "black"
        size: 9 //12
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16
        visible: !isCurrent && !option
    }

    FontAwesomeIcon {
        id: optionsIcon
        icon: FontAwesome.Icon.Cog
        color: "#515151"
        size: 9 //12s
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16
        visible: !isCurrent && option
    }

    BottomBorder{ color: colors.borderColor; visible: isCurrent }
    TopBorder{ color: colors.borderColor; visible: isCurrent }
//    DiceBorders.BottomBorder{ color: colors.borderColor}
    LeftBorder{ color: colors.borderColor }

    // BottomLine for App-Name-Item
    Rectangle {
        height: 1
        color:  "#428BCA"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        visible: index === 0
    }

    MouseArea {
        id: mouseArea
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
            leftSideBar.currentIndex = index
        }
    }

    states: [
        State {
            name: "NORMAL"
            PropertyChanges { target: listItemsDelegate; color: option ? "#e4e4e4" : "#f6f6f6" }
            PropertyChanges { target: buttonLabel; color: option ? "#515151" :"#666" }
//            PropertyChanges { target: buttonDescription; color: option ? "#515151" :"black" }
            PropertyChanges { target: icon; color: "black" }
            PropertyChanges { target: optionsIcon; color: "#515151" }
        },
        State {
            name: "HOVER"
            PropertyChanges { target: listItemsDelegate; color: "#4EA6EA" }
            PropertyChanges { target: buttonLabel; color: "white" }
//            PropertyChanges { target: buttonDescription; color: "#C5E6FF" }
            PropertyChanges { target: mainHeader; headerTxtColor: "white" }
            PropertyChanges { target: icon; color: "white" }
            PropertyChanges { target: optionsIcon; color: "white" }
        },
        State {
            name: "ACTIVE"
            PropertyChanges { target: listItemsDelegate; color: "#f4f4f4" }
        }
    ]

    transitions: [
        Transition {
            from: "NORMAL"; to: "HOVER"
                 ColorAnimation {target:listItemsDelegate; properties: "color"; duration: 300 }
                 ColorAnimation {target:buttonLabel; properties: "color"; duration: 100 }
//                 ColorAnimation {target:buttonDescription; properties: "color"; duration: 100 }
                 ColorAnimation {target:icon; properties: "color"; duration: 100 }
                 ColorAnimation {target:optionsIcon; properties: "color"; duration: 100 }
        }
    ]

    Rectangle {
        id: highlightRect
//                visible: control.pressed
        opacity: 0
        color: "#f2f2f2"
        property int radiusParameter: 10
        width: radiusParameter
        height: radiusParameter
        radius: 100
//        anchors.centerIn: parent
        x: mouseArea.mouseX - radiusParameter/2
        y: mouseArea.mouseY - radiusParameter/2
        border.width: 1

        visible: !isCurrent

        PropertyAnimation {
            id: anim1
            target: highlightRect
            property: "radiusParameter"
            running: mouseArea.pressed
            from: 0
            to: 100
//                    duration: 500
            easing.type: Easing.InOutQuad
            alwaysRunToEnd: true
        }
        PropertyAnimation {
            id: anim2
            running: mouseArea.pressed
            target: highlightRect
            property: "opacity"
            from: 1
            to: 0
            duration: 500
            easing.type: Easing.InOutQuad
            alwaysRunToEnd: true
        }
        PropertyAnimation {
            id: anim3
            running: mouseArea.pressed
            target: highlightRect
            property: "border.width"
            from: 1
            to: 0
            duration: 150
            easing.type: Easing.InOutQuad
            alwaysRunToEnd: true
        }
    }

}
