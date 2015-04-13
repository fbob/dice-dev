import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        Subheader { text: "Bounding Box" }
        VectorField {
            id: bbMin
            xLabel: "min X"
            yLabel: "min Y"
            zLabel: "min Z"
            methodName: "bounding_box_min"
        }
        VectorField {
            id: bbMax
            xLabel: "max X"
            yLabel: "max Y"
            zLabel: "max Z"
            methodName: "bounding_box_max"
        }
        Caption {
            text: "Additional spacing [%]"
            horizontalAlignment: "AlignHCenter"
        }
        VectorField {
            id: spacingInput
            xLabel: "Spacing X [%]"
            yLabel: "Spacing Y [%]"
            zLabel: "Spacing Z [%]"
            methodName: "spacing"
        }
        FlatButton {
            text: "Calculate Automatically"
            onClicked: {
                app.call("calculate_bounding_box")
            }
        }
    }
    Card {
        Subheader { text: "Cells" }
        ToggleButton {
            id: toggleSizeOrNumber
            uncheckedText: "Number of Cells"
            checkedText: "Cells Size Δs [m]"
            methodName: "app_config"
            callParameter: "blockMesh useCellSize"
        }
        VectorField {
            readOnly: toggleSizeOrNumber.checked
            xLabel: "Cells in X"
            yLabel: "Cells in Y"
            zLabel: "Cells in Z"
            dataType: "int"
            methodName: "n_cells"
        }
        VectorField {
            readOnly: !toggleSizeOrNumber.checked
            xLabel: "Δs in X [m]"
            yLabel: "Δs in Y [m]"
            zLabel: "Δs in Z [m]"
            methodName: "cell_size"
        }
    }
    Card {
        Subheader { text: "Boundaries" }
        TreeView {
            id: boundaries
            width: parent.width
            model: PythonListModel {
                loadMethod: "get_boundaries"
                changedCallback: "boundariesChanged"
            }
        }
        FoamDropDown {
            label: "Type"
            getModelMethod: "boundary_types"
            path: !!boundaries.currentNode ? "constant/polyMesh/blockMeshDict boundary " + boundaries.currentNode.model.index + " type": undefined
        }
    }
}
