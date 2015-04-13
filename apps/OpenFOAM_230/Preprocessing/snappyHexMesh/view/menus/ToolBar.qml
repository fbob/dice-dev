import QtQuick 2.4

import DICE.App 1.0

ToolBarMenu {

    ToolBarGroup {
        title: "Refinement Objects"

        BigToolBarButton {
            action: actions.addBox
        }
        BigToolBarButton {
            action: actions.addSphere
        }
        BigToolBarButton {
            action: actions.addCylinder
        }
        BigToolBarButton {
            action: actions.addPlate
        }
        BigToolBarButton {
            action: actions.addPlanePointAndNormal
        }
        BigToolBarButton {
            action: actions.addPlane3Points
        }
        BigToolBarButton {
            action: actions.addDisk
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
        title: "Mesh Tools"
        visible: app.status === "finished"

        flowLeftToRight: false

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
