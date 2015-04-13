import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        FoamToggleButton {
            label: "Add Layers"
            uncheckedText: "No"
            checkedText: "Yes"
            path: "system/snappyHexMeshDict addLayers"
        }
        Subheader { text: "Settings for Layer Addition" }
        FoamToggleButton {
            id: toggleButtonRelativeSize
            uncheckedText:  "Absolute Sizes [m]"
            checkedText: "Relative Sizes [-]"
            path: "system/snappyHexMeshDict addLayersControls relativeSizes"
        }
        FoamValue {
            label: "Expansion Ratio"
            path: "system/snappyHexMeshDict addLayersControls expansionRatio"
        }
        FoamValue {
            label: "Final Layer Thickness"
            path: "system/snappyHexMeshDict addLayersControls finalLayerThickness"
        }
        FoamValue {
            label: "Minimum Thickness"
            path: "system/snappyHexMeshDict addLayersControls minThickness"
        }
        FoamValue {
            label: "nGrow"
            path: "system/snappyHexMeshDict addLayersControls nGrow"
            dataType: "int"
        }
    }
    Card {
        Subheader { text: "Advanced Settings" }
        FoamValue {
            label: "Feature Angle [°]"
            path: "system/snappyHexMeshDict addLayersControls featureAngle"
            dataType: "int"
        }
        FoamValue {
            label: "nRelaxIter"
            path: "system/snappyHexMeshDict addLayersControls nRelaxIter"
            dataType: "int"
        }
        FoamValue {
            label: "nSmoothSurfaceNormals"
            path: "system/snappyHexMeshDict addLayersControls nSmoothSurfaceNormals"
            dataType: "int"
        }
        FoamValue {
            label: "nSmoothNormals"
            path: "system/snappyHexMeshDict addLayersControls nSmoothNormals"
            dataType: "int"
        }
        FoamValue {
            label: "nSmoothThickness"
            path: "system/snappyHexMeshDict addLayersControls nSmoothThickness"
            dataType: "int"
        }
        FoamValue {
            label: "maxFaceThicknessRatio"
            path: "system/snappyHexMeshDict addLayersControls maxFaceThicknessRatio"
        }
        FoamValue {
            label: "maxThicknessToMedialRatio"
            path: "system/snappyHexMeshDict addLayersControls maxThicknessToMedialRatio"
        }
        FoamValue {
            label: "minMedianAxisAngle [°]"
            path: "system/snappyHexMeshDict addLayersControls minMedianAxisAngle"
            dataType: "int"
        }
        FoamValue {
            label: "nBufferCellsNoExtrude"
            path: "system/snappyHexMeshDict addLayersControls nBufferCellsNoExtrude"
            dataType: "int"
        }
        FoamValue {
            label: "nLayerIter"
            path: "system/snappyHexMeshDict addLayersControls nLayerIter"
            dataType: "int"
        }
    }
}
