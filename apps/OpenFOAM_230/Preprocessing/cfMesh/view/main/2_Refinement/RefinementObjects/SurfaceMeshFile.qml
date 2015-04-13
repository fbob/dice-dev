import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Column {
    property alias additionalRefinementLevels: additionalRefinementLevels.path
    property alias refinementThickness: refinementThickness.path
    property alias cellSize: cellSize.path

    width: parent.width

    FoamDictCheck {
        id: foamDictCheck

        path: treeView.currentNode ? "system/meshDict surfaceMeshRefinement " + treeView.currentNode.text : undefined
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
//                refinementThickness.deleteFoamVar()
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
    }

    FoamValue {
        id: cellSize

        visible: foamDictCheck.exists && refinementOptionsToggle.checked
        enabled: foamDictCheck.exists
        label: "cellSize [m]"
        optional: true
    }

    FoamValue {
        id: refinementThickness

        visible: foamDictCheck.exists
        enabled: foamDictCheck.exists
        label: "refinementThickness [m]"
        optional: true
    }
}
