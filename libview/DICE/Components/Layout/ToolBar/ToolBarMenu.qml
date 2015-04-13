import QtQuick 2.4

import DICE.Components 1.0

Item {
    id: root

    default property alias children: toolBarContent.children

    // Background
    Item {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: colors.windowToolBarFrameColor
        }
        TopBorder {}
        BottomBorder {}
    }

    // Controls
    ScrollView_DICE {
        id: scrollView

        width: parent.width
        height: parent.height

        Row {
            id: toolBarContent

            width: childrenRect.width
            height: scrollView.height - 15
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -5
        }
    }
}
