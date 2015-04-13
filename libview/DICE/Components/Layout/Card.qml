import QtQuick 2.4
import QtGraphicalEffects 1.0

import DICE.Theme 1.0
import DICE.Components 1.0

//TODO: Better and cleaner structure
Rectangle {
    id: root

    property string title
    property bool expanded: true
    property int contentMargin: 20
    property int contentTopMargin: contentMargin
    property int contentBottomMargin: contentMargin
    property alias color: background.color
    property bool visibleShadowAndBorder: true
    property bool expanderVisible: true

    property Component header

    default property alias children: content.children
    signal clicked
    signal entered
    signal exited

    width: parent.width
    height: {
        if (expanded && !!header) {
            return content.height + contentTopMargin + contentBottomMargin + expander.height + headerLoader.height
        } else if (expanded) {
            return content.height + contentTopMargin + contentBottomMargin + expander.height
        } else {
            return content.children[0].implicitHeight + contentTopMargin + contentBottomMargin + expander.height + headerLoader.height
        }
    }

    // function to get the height after loading complete (Component.onCompleted does not work !!!)
    function repeatHeightCalculation(){
        if (expanded && !!header) {
            return content.height + contentTopMargin + contentBottomMargin + expander.height + headerLoader.height
        } else if (expanded) {
            return content.height + contentTopMargin + contentBottomMargin + expander.height
        } else {
            return content.children[0].implicitHeight + contentTopMargin + contentBottomMargin + expander.height + headerLoader.height
        }
    }

    anchors.margins: -1
    border.width: visibleShadowAndBorder ? 1 : 0
    opacity: enabled ? 1 : 0.5

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onClicked: root.clicked()
        onEntered: root.entered()
        onExited: root.exited()
    }

    RectShadow {
        visible: parent.visibleShadowAndBorder
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#fff"
    }

    Item {
        anchors.fill: parent
        clip: true

        Loader {
            id: headerLoader

            sourceComponent: root.header
            width: parent.width
            enabled: !!root.header
        }

        Column {
            id: content

            spacing: 5
            anchors {
                left: parent.left
                right: parent.right
                top: !!root.header ? headerLoader.bottom : parent.top
                leftMargin: root.contentMargin
                rightMargin: root.contentMargin
                topMargin: root.contentTopMargin
                bottomMargin: root.contentBottomMargin
            }
        }

        Rectangle {
            id: expander

            height: content.children.length > 1 ? 15 : 0
            width: parent.width
            color: root.color
            anchors.bottom: parent.bottom
            visible: content.children.length > 1 && expanderVisible

            FontAwesomeIcon {
                icon: root.expanded ?
                          FontAwesome.Icon.CaretUp :
                          FontAwesome.Icon.CaretDown
                color: root.expanded ? colors.borderColor : "#000"
                size: 10
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.expanded = !root.expanded
                hoverEnabled: true
                onEntered: {
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    cursorShape = Qt.ArrowCursor
                }
            }
        }
    }

    Behavior on height {
        NumberAnimation {
            easing.type: Easing.InOutQuad;
            duration: 100
        }
    }
}
