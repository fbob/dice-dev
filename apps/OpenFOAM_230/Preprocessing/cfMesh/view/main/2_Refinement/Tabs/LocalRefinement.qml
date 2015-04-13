import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Local Refinement"

    enabled: !!treeView.currentNode && treeView.currentNode.isRegion

    visibleShadowAndBorder: false
    expanderVisible: false

    FoamDictCheck {
        id: foamDictCheck

        path: treeView.currentNode ? "system/meshDict localRefinement " + treeView.currentNode.text : ""
    }

    ToggleButton {
        id: refinementOptionsToggle

        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        uncheckedText: "Levels"
        checkedText: "cellSize"
        onCheckedChanged: {
            if (checked) {
                additionalRefinementLevels.deleteFoamVar()
            }
            else {
                cellSize.deleteFoamVar()
            }
        }
    }

    FoamValue {
        id: additionalRefinementLevels

        visible: foamDictCheck.exists && !refinementOptionsToggle.checked
        enabled: foamDictCheck.exists
        label: "additionalRefinementLevels"
        optional: true
        path: foamDictCheck.path + " additionalRefinementLevels"
        dataType: "int"
    }

    FoamValue {
        id: cellSize

        visible: foamDictCheck.exists && refinementOptionsToggle.checked
        enabled: foamDictCheck.exists
        label: "cellSize [m]"
        optional: true
        path: foamDictCheck.path + " cellSize"
    }

    FoamValue {
        id: refinementThickness

        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        label: "refinementThickness [m]"
        optional: true
        path: foamDictCheck.path + " refinementThickness"
    }

    Row {
        width: parent.width
        spacing: 10

        FlatButton {
            width: (parent.width - parent.spacing)/2
            enabled: !foamDictCheck.exists
            opacity: 1 ? !foamDictCheck.exists : 0
            text: "Add"
            onClicked: {
                foamDictCheck.createDict()
            }
        }
        FlatButton {
            width: (parent.width - parent.spacing)/2
            enabled: foamDictCheck.exists
            opacity: 1 ? foamDictCheck.exists : 0
            text: "Delete"
            onClicked: {
                foamDictCheck.removeDict()
            }
        }
    }
}
