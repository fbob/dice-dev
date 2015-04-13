import QtQuick 2.4
import QtQuick.Window 2.0

import DICE.Components 1.0

Item {
    id: root

    property color color: "white"
    property int frameSize: 2

    anchors.fill: parent

    LeftBorder { color: root.color; width: frameSize }
    RightBorder { color: root.color; width: frameSize }
    TopBorder { color: root.color; height: frameSize }
    BottomBorder { color: root.color; height: frameSize }
}
