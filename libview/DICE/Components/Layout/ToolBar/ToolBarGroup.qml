import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import DICE.Theme 1.0

Item {
    property alias title: groupLabel.text
    default property alias menuItems: menuItemsColumn.children
    property bool flowLeftToRight : true

    width: menuItemsColumn.width + divider.width*2
    height: parent.height

    Column {
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Item {
            id: groupName

            width: parent.width - divider.width
            height: 15

            BasicText {
                id: groupLabel

                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: colors.windowToolBarGroupTextColor
                scalablePixelSize: 11
                font.letterSpacing: 1.5
                wrapMode: "WordWrap"
            }
        }

        Flow {
            id: menuItemsColumn

            spacing: 2
            anchors.left: parent.left
            anchors.leftMargin: divider.width/2
            height: parent.height - groupName.height
            flow: flowLeftToRight ? Flow.LeftToRight : Flow.TopToBottom
        }
    }

    ToolBarDivider {
        id: divider
        anchors.right: parent.right
    }
}
