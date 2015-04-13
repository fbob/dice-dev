import QtQuick 2.4

import DICE.App.Foam 1.0

Column {
    property alias cellSize: cellSize.path
    property alias centre: centre.path
    property alias lengthX: lengthX.path
    property alias lengthY: lengthY.path
    property alias lengthZ: lengthZ.path

    width: parent.width

    FoamValue {
        id: cellSize
        label: "cellSize [m]"
    }
    FoamVector {
        id: centre
        xLabel: "centreX"
        yLabel: "centreY"
        zLabel: "centreZ"
    }
    FoamValue {
        id: lengthX
        label: "lengthX [m]"
    }
    FoamValue {
        id: lengthY
        label: "lengthY [m]"
    }
    FoamValue {
        id: lengthZ
        label: "lengthZ [m]"
    }
}

