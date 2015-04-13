import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

Rectangle {
    width: parent.width
    height: col.height
    color: "#fff"

    Column {
        id: col
        width: parent.width

        // Devider
        Item {
            id: divider

            height: 10
            width: parent.width - 30
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.1

            BottomBorder { color: "#636363"; anchors.bottomMargin: parent.height/2 }
        }

        BasicText {
            visible: section !== "opt" && section !== ""
            text: section
            height: 20
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: colors.windowToolBarGroupTextColor
            scalablePixelSize: 11
            font.letterSpacing: 1.5
        }
    }

    RightBorder {}
    LeftBorder {}
}
