import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

MainHeader {
    id: root

    FlatButton {
        width: 35
        height: 35
        anchors.verticalCenter: parent.verticalCenter
        iconSource: "images/zoomIn.svg"
        onClicked: {
            desk.workSpace.zoom(desk.workSpace.scale, 120)
        }
    }

    FlatButton {
        width: 35
        height: 35
        anchors.verticalCenter: parent.verticalCenter
        iconSource: "images/zoomOut.svg"
        onClicked: {
            desk.workSpace.zoom(desk.workSpace.scale, -120)
        }
    }

    BasicText {
        property real scaleInPercent: desk.workSpace.scale*100

        text: scaleInPercent.toFixed(2)+" %"
        anchors.verticalCenter: parent.verticalCenter
    }
}
