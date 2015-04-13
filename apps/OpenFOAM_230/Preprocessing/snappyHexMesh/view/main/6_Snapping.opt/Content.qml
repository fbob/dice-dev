import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        FoamToggleButton {
            label: "Activate Snapping"
            uncheckedText: "No"
            checkedText: "Yes"
            path: "system/snappyHexMeshDict snap"
        }

        Subheader { text: "Settings for the Snapping" }

        FoamToggleButton {
            label: "Implicit Feature Snap"
            uncheckedText: "Off"
            checkedText: "On"
            path: "system/snappyHexMeshDict snapControls implicitFeatureSnap"
        }
        FoamToggleButton {
            label: "Explicit Feature Snap"
            uncheckedText: "Off"
            checkedText: "On"
            path: "system/snappyHexMeshDict snapControls explicitFeatureSnap"
        }
        FoamToggleButton {
            label: "Multi Region Feature Snap"
            uncheckedText: "Off"
            checkedText: "On"
            path: "system/snappyHexMeshDict snapControls multiRegionFeatureSnap"
        }
        FoamValue {
            label: "nSmoothPatch"
            path: "system/snappyHexMeshDict snapControls nSmoothPatch"
            dataType: "int"
        }
        FoamValue {
            label: "tolerance"
            path: "system/snappyHexMeshDict snapControls tolerance"
        }
        FoamValue {
            label: "nSolveIter"
            path: "system/snappyHexMeshDict snapControls nSolveIter"
            dataType: "int"
        }
        FoamValue {
            label: "nRelaxIter"
            path: "system/snappyHexMeshDict snapControls nRelaxIter"
            dataType: "int"
        }
        FoamValue {
            label: "nFeatureSnapIter"
            path: "system/snappyHexMeshDict snapControls nFeatureSnapIter"
            dataType: "int"
        }
    }
}
