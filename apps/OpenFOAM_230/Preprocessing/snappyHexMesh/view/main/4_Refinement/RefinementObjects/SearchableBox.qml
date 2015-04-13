import QtQuick 2.4

import DICE.App.Foam 1.0

Column {
    property alias min_path: min.path
    property alias max_path: max.path

    width: parent.width

    FoamVector {
        id: min
        xLabel: "minX"
        yLabel: "minY"
        zLabel: "minZ"
    }
    FoamVector {
        id: max
        xLabel: "maxX"
        yLabel: "maxY"
        zLabel: "maxZ"
    }
}
