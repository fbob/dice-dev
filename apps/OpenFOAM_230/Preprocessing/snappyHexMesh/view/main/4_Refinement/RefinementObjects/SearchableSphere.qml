import QtQuick 2.4

import DICE.App.Foam 1.0

Column {
    property alias centre_path: centre.path
    property alias radius_path: radius.path

    width: parent.width

    FoamVector {
        id: centre
        xLabel: "Centre X"
        yLabel: "Centre Y"
        zLabel: "Centre Z"
    }
    FoamValue {
        id: radius
        width: parent.width/2
        label: "Radius [m]"
    }
}

