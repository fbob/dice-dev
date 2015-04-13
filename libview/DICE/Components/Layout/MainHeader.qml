import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    id: root

    property alias text: menuText.text
    property alias textColor: menuText.color
    property alias imageSource: menuButton.imageSource
    property alias menu: menuButton.menu

    property alias color: background.color
    property alias border: background.border

    default property alias children: row.children


    height: 50
    width: parent.width

    BottomShadow {}

    Rectangle {
        id: background

        width: root.width
        height: root.height
        color: colors.menuHeaderBackgroundColor
        border.color: colors.borderColor
        border.width: 1

        BottomBorder {}
    }

    ScrollView_DICE {
        id: scrollView

        width: parent.width
        height: parent.height
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        Row {
            id: row

            spacing: 5
            width: childrenRect.width
            height: scrollView.height - 10
            anchors.top: parent.top
            anchors.topMargin: 5
            clip: true

            MenuButton {
                id: menuButton
            }

            MenuText {
                id: menuText

                anchors.verticalCenter: parent.verticalCenter
                color: colors.mainHeaderColor
            }
        }
    }
}
