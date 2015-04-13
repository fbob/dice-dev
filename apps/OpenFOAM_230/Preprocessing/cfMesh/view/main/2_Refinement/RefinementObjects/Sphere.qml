import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Column {
    property alias cellSize: cellSize.path
    property alias centre: centre.path
    property alias radius: radius.path
    property alias refinementThickness: refinementThickness.path

    width: parent.width

    FoamValue {
        id: cellSize
        label: "cellSize [m]"
    }
    FoamVector {
        id: centre
        xLabel: "Centre X"
        yLabel: "Centre Y"
        zLabel: "Centre Z"
    }
    FoamValue {
        id: radius
        label: "Radius [m]"
    }
    FoamValue {
        id: refinementThickness
        label: "refinementThickness [m]"
    }
}
