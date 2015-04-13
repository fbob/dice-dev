import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.Components 1.0

Item {
    id: root
    default property alias children: innerRectangle_2.children
    property alias contentHeight: innerRectangle.height
    property alias contentWidth: innerRectangle_2.width
    property alias activeScrolling: scrollView.activeScrolling

    clip: true


    //Background
    property Component background: Rectangle {
        id: background
        anchors.fill: parent
        color: colors.secondBackgroundColor
        anchors.margins: 5
        border.width: 1
        border.color: colors.borderColor
        clip: true
    }

    // Content
    ScrollView_DICE {
        id: scrollView
        width: parent.width
        height: parent.height - 12

        Item {
            id: innerRectangle
            width: scrollView.contentWidth
            height: children.height

            Item {
                id: innerRectangle_2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: variables.windowPadding*2
                height: root.contentHeight
            }
        }
    }
}
