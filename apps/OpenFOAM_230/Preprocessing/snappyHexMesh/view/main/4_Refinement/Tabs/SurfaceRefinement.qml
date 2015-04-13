import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Surface Refinement"

    enabled: !!treeView.currentNode && !treeView.currentNode.model.isRefinementObject && !!treeView.currentNodePath
    visibleShadowAndBorder: false
    expanderVisible: false

    FoamVector2D {
        id: levelVector2Dglobal

        xLabel: "Min Level"
        yLabel: "Max Level"
        dataType: "int"

        enabled: !treeView.currentNode.model.isRegion
        visible: enabled

        path: "system/snappyHexMeshDict castellatedMeshControls refinementSurfaces " + treeView.currentNodePath[0] + " level"
    }

    FoamVector2D {
        id: levelVector2Dregion

        xLabel: "Min Level"
        yLabel: "Max Level"
        dataType: "int"

        enabled: treeView.currentNode.model.isRegion && localSurfaceRegionDict.exists
        visible: enabled

        path: "system/snappyHexMeshDict castellatedMeshControls refinementSurfaces " + treeView.currentNodePath[0] + " regions " + treeView.currentNodePath[1] + " level"
    }

    FoamDictCheck {
        id: localSurfaceRegionDict

        path: "system/snappyHexMeshDict castellatedMeshControls refinementSurfaces " + treeView.currentNodePath[0] + " regions " + treeView.currentNodePath[1]
    }

    CheckBox {
        id: useGlobaLevel

        text: "Use parent level"
        enabled: treeView.currentNode.model.isRegion
        visible: enabled
        checked: !localSurfaceRegionDict.exists
        onClicked: {
            if (checked && localSurfaceRegionDict.exists) {
                localSurfaceRegionDict.removeDict()
            }
            else {
                app.call("create_default_region_level", [localSurfaceRegionDict.path])
                localSurfaceRegionDict.checkIfDictExists()
            }
        }
    }

    // Convert surface to region
    // (mostly used for porous media and multi region meshing)
    // =======================================================
    ToggleButton {
        id: convertToRegion

        label: "Convert to Region"
        enabled: !treeView.currentNode.model.isRegion
        visible: enabled
        methodName: "convert_to_region"
        callParameter: treeView.currentNodePath[0]
    }

    FoamDropDown {
        id: cellZoneInside

        label: "Cell Zone"
        enabled: convertToRegion.checked
        visible: enabled
        path: "system/snappyHexMeshDict castellatedMeshControls refinementSurfaces " + treeView.currentNodePath[0] + " cellZoneInside"
        modelPath: "cellZoneInside"
    }

    FoamDropDown {
        id: faceType

        label: "Face Type"
        enabled: convertToRegion.checked
        visible: enabled
        path: "system/snappyHexMeshDict castellatedMeshControls refinementSurfaces " + treeView.currentNodePath[0] + " faceType"
        modelPath: "faceType"
    }
}

