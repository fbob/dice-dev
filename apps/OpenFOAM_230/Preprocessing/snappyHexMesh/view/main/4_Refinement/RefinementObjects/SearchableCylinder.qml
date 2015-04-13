import QtQuick 2.4

import DICE.App.Foam 1.0

Column {
    property alias point_1_path: point_1.path
    property alias point_2_path: point_2.path
    property alias radius_path: radius.path

    width: parent.width

    FoamVector {
        id: point_1
        xLabel: "Point1 X"
        yLabel: "Point1 Y"
        zLabel: "Point1 Z"
    }
    FoamVector {
        id: point_2
        xLabel: "Point2 X"
        yLabel: "Point2 Y"
        zLabel: "Point2 Z"
    }
    FoamValue {
        id: radius
        width: parent.width/2
        label: "Radius [m]"
    }
}

