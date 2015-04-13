import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Region Refinement"

    enabled: !!treeView.currentNodePath && (treeView.currentNode.model.isRefinementObject || treeView.currentNode.model.type === "stl_file")
    visibleShadowAndBorder: false
    expanderVisible: false

    FoamDictCheck {
        id: refinementRegion

        path: "system/snappyHexMeshDict castellatedMeshControls refinementRegions " + treeView.currentNodePath[0]
    }

    FoamDropDown {
        id: regionsLevelsMode

        enabled: refinementRegion.exists && (treeView.currentNode.model.isRefinementObject || treeView.currentNode.model.type === "stl_file")
        visible: enabled
        label: "Mode"
        path: refinementRegion.path + " mode"
        modelPath: {
            var currentNodeObjectType = treeView.currentNode.model.type
            if (currentNodeObjectType === "stl_file")
                "refinementObjects objectsRefinementModeSTL_file"
            if (currentNodeObjectType === "searchableBox"
                    || currentNodeObjectType === "searchableSphere"
                    || currentNodeObjectType === "searchableCylinder")
                "refinementObjects objectsRefinementMode3D"
            else
                "refinementObjects objectsRefinementMode2D"
        }
    }

    Repeater {
        id: regionLevels

        model: PythonListModel {
            loadMethod: "get_region_levels_list_length"
            loadParameters: [treeView.currentNodePath[0]]
            changedCallback: "regionLevelsListChanged"
        }

        delegate: Row {
            spacing: 10
            width: parent.width
            enabled: (treeView.currentNode.model.isRefinementObject || treeView.currentNode.model.type === "stl_file") && refinementRegion.exists
            visible: enabled

            FoamVector2D {
                width: (parent.width - parent.spacing)*0.9
                xLabel: "Distance [m]"
                yLabel: "Level"
                xDataType: "double"
                xEnabled: regionsLevelsMode.currentText === "distance"
                yDataType: "int"
                path: refinementRegion.path + " levels " + index
            }
            FlatButton {
                text: "-"
                width: (parent.width - parent.spacing)*0.1
                onClicked: {
                    app.call("remove_region_level", [treeView.currentNodePath[0], index])
                    refinementRegion.checkIfDictExists()
                    regionLevelsListChanged()
                }
            }
        }
    }

    FlatButton {
        text: "Add level"
        visible: regionsLevelsMode.currentText === "distance" || regionLevels.count === 0
        width: parent.width
        onClicked: {
            app.call("add_region_level", [treeView.currentNodePath[0], regionLevels.count, treeView.currentNode.model.type])
            refinementRegion.checkIfDictExists()
            regionLevelsListChanged()
        }
    }
}

