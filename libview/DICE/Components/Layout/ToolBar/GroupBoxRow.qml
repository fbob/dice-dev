import QtQuick 2.2
import QtQuick.Layouts 1.1


Item {
    width: menuItemsRow.width
    height: parent.height
    clip: true

    property bool typeRow: true
    property alias title: groupLabel.text
    default property alias menuItems: menuItemsRow.children

    Column {
        width: parent.width
        height: parent.height
        spacing: 2

        Row {
            id: menuItemsRow
            spacing: 10
//            width: parent.width
            height: parent.height - groupName.height
            visible: typeRow
        }

        Item {
            id: groupName
            width: parent.width
            height: 15

            Text {
                id: groupLabel
                anchors.fill: parent
                font.pixelSize: 11
                font.family: fonts.boldDescription
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
                color: colors.mainTextColor
                font.letterSpacing: 1.5
                opacity: 0.5
            }
        }
    }

}
