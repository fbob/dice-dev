import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Boundary Layers"

//    enabled: !!treeView.currentNode && treeView.currentNode.isRegion

    visibleShadowAndBorder: false
    expanderVisible: false

    Subheader { text: "Global" }

    FoamValue {
        label: "nLayers"
        optional: true
        path: "system/meshDict boundaryLayers nLayers"
    }

    FoamValue {
        label: "thicknessRatio"
        optional: true
        path: "system/meshDict boundaryLayers thicknessRatio"
    }

    FoamValue {
        label: "maxFirstLayerThickness [m]"
        optional: true
        path: "system/meshDict boundaryLayers maxFirstLayerThickness"
    }

    Subheader { text: "Local" }

    FoamDictCheck {
        id: foamDictCheck

        path: treeView.currentNode ? "system/meshDict boundaryLayers patchBoundaryLayers " + treeView.currentNode.text : ""
    }

    FoamValue {
        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        label: "nLayers"
        optional: true
        path: foamDictCheck.path + " nLayers"
    }

    FoamValue {
        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        label: "nLayers"
        optional: true
        path: foamDictCheck.path + " nLayers"
    }

    FoamValue {
        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        label: "thicknessRatio"
        optional: true
        path: foamDictCheck.path + " thicknessRatio"
    }

    FoamValue {
        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        label: "maxFirstLayerThickness [m]"
        optional: true
        path: foamDictCheck.path + " maxFirstLayerThickness"
    }

    FoamValue {
        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        label: "allowDiscontinuity"
        optional: true
        path: foamDictCheck.path + " allowDiscontinuity"
    }

//    ToggleButton {
//        // TODO: replace with FoamToggleButton
//        visible: foamDictCheck.dictExists
//        enabled: foamDictCheck.dictExists
//        label: "allowDiscontinuity"
//        path: foamDictCheck.path + " allowDiscontinuity"
//    }

    Row {
        width: parent.width
        spacing: 10

        FlatButton {
            width: (parent.width - parent.spacing)/2
            enabled: !foamDictCheck.exists && treeView.currentNode.isRegion
            opacity: 1 ? !foamDictCheck.exists && treeView.currentNode.isRegion : 0
            text: "Add"
            onClicked: {
                foamDictCheck.createDict()
            }
        }
        FlatButton {
            width: (parent.width - parent.spacing)/2
            enabled: foamDictCheck.exists && treeView.currentNode.isRegion
            opacity: 1 ? foamDictCheck.exists && treeView.currentNode.isRegion : 0
            text: "Delete"
            onClicked: {
                foamDictCheck.removeDict()
            }
        }
    }
}
