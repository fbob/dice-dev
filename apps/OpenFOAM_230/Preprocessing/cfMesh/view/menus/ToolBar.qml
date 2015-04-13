import DICE.App 1.0
import DICE.App.Foam 1.0

ToolBarMenu {

    ToolBarGroup {
        title: "cartesian / tet"

        FoamRadioButtonGroup {
            width: 120
            path: "system/controlDict application"
            modelPath: "mesher"
        }
    }

    ToolBarGroup {
        title: "Surface Tools"

        BigToolBarButton {
            action: actions.surfaceGenerateBoundingBoxAction
        }
    }

    ToolBarGroup {
        title: "Refinement Objects"

        BigToolBarButton {
            action: actions.addBox
        }
        BigToolBarButton {
            action: actions.addSphere
        }
        BigToolBarButton {
            action: actions.addCone
        }
        BigToolBarButton {
            action: actions.addLine
        }
        BigToolBarButton {
            action: actions.addSurfaceMeshRefinement
        }
    }

    ToolBarGroup {
        title: "Decomposition / Parallel Run"

        BigToolBarButton {
            action: actions.openDecompositionOptions
        }
    }

    ToolBarGroup {
        title: "External Tools"
        BigToolBarButton {
            action: actions.openParaview
        }
    }

    ToolBarGroup {
        title: "Treeview"

        property var treeView: appRoot.contentItems["Refinement"].treeView

        visible: !!treeView && !!treeView.currentNode && treeView.currentNode.model.isRefinementObject
        flowLeftToRight: false

        SmallToolBarButton {
            action: actions.removeRefinementObject
        }
        SmallToolBarButton {
            action: actions.renameRefinementObject
        }
    }

    ToolBarGroup {
        title: "Mesh Utilities"
        flowLeftToRight: false

        visible: app.status === "finished"

        SmallToolBarButton {
            action: actions.runCheckMesh
        }
        SmallToolBarButton {
            action: actions.runRenumberMesh
        }
        SmallToolBarButton {
            action: actions.clearMesh
        }
    }
}
