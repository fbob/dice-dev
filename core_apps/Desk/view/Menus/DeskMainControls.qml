import QtQuick 2.4

import DICE.Components 1.0

Item {
    width: row.width
    height: parent.height - 10

    enabled: !!deskData.currentFocusedStreamItem && deskData.currentFocusedStreamItem.focus
    opacity: enabled ? 1 : 0.5

    Rectangle {
        color: colors.mainBackgroundColor
        width: parent.width
        height: 60*0.7
        radius: 15
        border.color: colors.borderColor
        border.width: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Row {
        id: row
        width: childrenRect.width
        height: parent.height

        Item {
            width: 40
            height: parent.height
        }
        Item {
            width: 60
            height: parent.height

            FloatingButton {
                color: "#DF5745"
                action: actions.runSelectedStreamItem
            }
        }
        Item {
            width: 40
            height: parent.height

            FloatingButton {
                color: "#DF5745"
                action: actions.killCurrentRunningSelectedStreamItem
                visible: action.enabled
            }
        }
    }
}
