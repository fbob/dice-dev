import QtQuick 2.4

import DICE.App.Foam 1.0

Column {
    property alias point1_path: point1.path
    property alias point2_path: point2.path
    property alias point3_path: point3.path

    width: parent.width

    FoamVector {
        id: point1
        xLabel: "Point_1 X"
        yLabel: "Point_1 Y"
        zLabel: "Point_1 Z"
    }
    FoamVector {
        id: point2
        xLabel: "Point_2 X"
        yLabel: "Point_2 Y"
        zLabel: "Point_2 Z"
    }
    FoamVector {
        id: point3
        xLabel: "Point_3 X"
        yLabel: "Point_3 Y"
        zLabel: "Point_3 Z"
    }
}

