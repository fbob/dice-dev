import QtQuick 2.4

import DICE.Theme 1.0
import DICE.Components 1.0

SubheaderText {
    width: parent.width
    height: implicitHeight*2
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: "#333"

    BorderImage {
        id: bottomImage

        width: parent.width
        height: 3
        anchors {
            topMargin: -6
            rightMargin: -5
            bottom: parent.bottom
            bottomMargin: 0
            leftMargin: -5
        }
        source: 'images/box-shadow.png'
        border {
            top: 10
            right: 3
            bottom: 7
            left: 3
        }
        opacity: 0.1
        rotation: 180
    }
}
