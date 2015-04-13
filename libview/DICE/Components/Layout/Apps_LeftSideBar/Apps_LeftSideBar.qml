import QtQuick 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.1

import DICE.Components 1.0
import DICE.Components.Styles 1.0

Rectangle {
    property alias currentIndex: itemList.currentIndex
    property alias model: itemList.model
    property var optionsModel

    Layout.minimumWidth: 200
//    Layout.preferredWidth: 200 //260 //300
    Layout.fillHeight: true

    color: colors.mainBackgroundColor

    Rectangle {
        id: listViewItem
        anchors.margins: 5
        anchors.fill: parent
        color: "#eee"
        border.width: 1
        border.color: colors.borderColor

        ScrollView_DICE {
            anchors.fill: parent

            ListView{
                id: itemList
                anchors.fill: parent
                delegate: Apps_ListItemsDelegate { id:listItemsDelegate }
            }

            style: ScrollViewStyle_DICE {}
        }
    }
}
