import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Layers Addition"

    enabled: !!treeView.currentNode && treeView.currentNode.model.isRegion && !treeView.currentNode.isRefinementObject
    visibleShadowAndBorder: false
    expanderVisible: false

    FoamDictCheck {
        id: layersDict

        path: "system/snappyHexMeshDict addLayersControls layers " + treeView.currentNode.text
    }

    FoamValue {
        label: "Number of Layers"
        path: "system/snappyHexMeshDict addLayersControls layers " + treeView.currentNode.text + " nSurfaceLayers"

        visible: layersDict.exists
        enabled: layersDict.exists
        dataType: "int"
    }

    Row {
        width: parent.width
        spacing: 10

        FlatButton {
            width: (parent.width - parent.spacing)/2
            enabled: !layersDict.exists && treeView.currentNode.isRegion
            opacity: 1 ? !layersDict.exists && treeView.currentNode.isRegion && !treeView.currentNode.isRefinementObject : 0
            text: "Add"
            onClicked: {
                layersDict.createDict({"nSurfaceLayers": 0})
            }
        }
        FlatButton {
            width: (parent.width - parent.spacing)/2
            enabled: layersDict.exists && treeView.currentNode.isRegion
            opacity: 1 ? layersDict.exists && treeView.currentNode.isRegion && !treeView.currentNode.isRefinementObject : 0
            text: "Delete"
            onClicked: {
                layersDict.removeDict()
            }
        }
    }
}
