import QtQuick 2.4

import DICE.App.Foam 1.0

Column {
    property alias origin_path: origin.path
    property alias normal_path: normal.path
    property alias radius_path: radius.path

    width: parent.width

    FoamVector {
        id: origin
        xLabel: "Origin X"
        yLabel: "Origin Y"
        zLabel: "Origin Z"
    }
    FoamVector {
        id: normal
        xLabel: "Normal X"
        yLabel: "Normal Y"
        zLabel: "Normal Z"
    }
    FoamValue {
        id: radius
        width: parent.width/2
        label: "Radius [m]"
    }
}
