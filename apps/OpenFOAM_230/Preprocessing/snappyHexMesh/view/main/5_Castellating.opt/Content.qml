import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        FoamToggleButton {
            label: "Activate CastellatedMesh Generation"
            uncheckedText: "No"
            checkedText: "Yes"
            path: "system/snappyHexMeshDict castellatedMesh"
        }
        FoamToggleButton {
            label: "Activate CastellatedMesh Generation"
            uncheckedText: "No"
            checkedText: "Yes"
            path: "system/snappyHexMeshDict castellatedMesh"
        }
        Subheader { text: "Settings for the castellatedMesh generation" }
        FoamValue {
            label: "Resolve Feature Angle [°]"
            path: "system/snappyHexMeshDict castellatedMeshControls resolveFeatureAngle"
            dataType: "int"
        }
        FoamValue {
            label: "Resolve Feature Angle [°]"
            path: "system/snappyHexMeshDict castellatedMeshControls resolveFeatureAngle"
            dataType: "int"
        }
        FoamValue {
            label: "Gap Level Increment"
            path: "system/snappyHexMeshDict castellatedMeshControls gapLevelIncrement"
            dataType: "int"
            optional: true
        }
        FoamValue {
            label: "Gap Level Increment"
            path: "system/snappyHexMeshDict castellatedMeshControls gapLevelIncrement"
            dataType: "int"
            optional: true
        }
        FoamValue {
            label: "Planar Angle [°]"
            path: "system/snappyHexMeshDict castellatedMeshControls planarAngle"
            dataType: "int"
            optional: true
        }
        FoamValue {
            label: "Maximum Local Cells"
            path: "system/snappyHexMeshDict castellatedMeshControls maxLocalCells"
            dataType: "int"
        }
        FoamValue {
            label: "Maximum Global Cells"
            path: "system/snappyHexMeshDict castellatedMeshControls maxGlobalCells"
            dataType: "int"
        }
        FoamValue {
            label: "Minimum Refinement Cells"
            path: "system/snappyHexMeshDict castellatedMeshControls minRefinementCells"
            dataType: "int"
        }
        FoamValue {
            label: "Number of Cells between Levels"
            path: "system/snappyHexMeshDict castellatedMeshControls nCellsBetweenLevels"
            dataType: "int"
        }
        FoamToggleButton {
            label: "Allow Free Standing Zone Faces"
            uncheckedText: "No"
            checkedText: "Yes"
            path: "system/snappyHexMeshDict castellatedMeshControls allowFreeStandingZoneFaces"
        }
    }
}
