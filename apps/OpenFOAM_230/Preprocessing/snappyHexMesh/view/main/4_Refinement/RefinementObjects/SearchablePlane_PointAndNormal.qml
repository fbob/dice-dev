import QtQuick 2.4

import DICE.App.Foam 1.0

Column {
    property alias basePoint_path: basePoint.path
    property alias normalVector_path: normalVector.path

    width: parent.width

    FoamVector {
        id: basePoint
        xLabel: "BasePoint X"
        yLabel: "BasePoint Y"
        zLabel: "BasePoint Z"
    }
    FoamVector {
        id: normalVector
        xLabel: "NormalVector X"
        yLabel: "NormalVector Y"
        zLabel: "NormalVector Z"
    }
}

