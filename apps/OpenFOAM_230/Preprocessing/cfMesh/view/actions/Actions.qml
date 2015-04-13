import QtQuick 2.4
import QtQuick.Controls 1.3

Item {
    property var treeView: appRoot.contentItems["Refinement"].treeView

    // Surface Tools
    // =============
    SurfaceGenerateBoundingBox { id: surfaceGenerateBoundingBox }
    property Action surfaceGenerateBoundingBoxAction: Action {
        text: "Bounding Box"
        tooltip: "Generate Surface Bounding Box"
        iconSource: "images/generateSurfaceBox.svg"
        iconName: text
        enabled: treeView.currentNode.model.type === "stl_file"
        onTriggered:  {
            leftOptionsSideBar.content = surfaceGenerateBoundingBox
            leftOptionsSideBar.open()
        }
    }

    // Refinement Objects
    // ==================
    property Action addBox: Action {
        text: "Box"
        tooltip: "Add Refinement Box"
        iconSource: "images/refinementBox.svg"
        iconName: text
        onTriggered:  {
            appRoot.openTab("Refinement")
            app.call("add_object_refinements", ["refinementBox"], function(realObjName){treeView.setCurrentNode(realObjName)})
        }
    }
    property Action addSphere: Action {
        text: "Sphere"
        tooltip: "Add Refinement Sphere"
        iconSource: "images/refinementSphere.svg"
        iconName: text
        onTriggered:  {
            appRoot.openTab("Refinement")
            app.call("add_object_refinements", ["refinementSphere"], function(realObjName){treeView.setCurrentNode(realObjName)})
        }
    }
    property Action addCone: Action {
        text: "Cone"
        tooltip: "Add Refinement Cone"
        iconSource: "images/refinementCone.svg"
        iconName: text
        onTriggered:  {
            appRoot.openTab("Refinement")
            app.call("add_object_refinements", ["refinementCone"], function(realObjName){treeView.setCurrentNode(realObjName)})
        }
    }
    property Action addLine: Action {
        text: "Line"
        tooltip: "Add Refinement Line"
        iconSource: "images/refinementLine.svg"
        iconName: text
        onTriggered:  {
            appRoot.openTab("Refinement")
            app.call("add_object_refinements", ["refinementLine"], function(realObjName){treeView.setCurrentNode(realObjName)})
        }
    }
    property Action addSurfaceMeshRefinement: Action {
        text: "SurfaceMeshRefinement"
        tooltip: "Add SurfaceMeshFile for Refinement"
        iconSource: "images/surfaceMeshRefinement.svg"
        iconName: text
        onTriggered: {
            fileDialog.open("add_surface_mesh_refinement", "Select Files for Import", ["STL File (*.stl)"], false)
        }
    }

    // Decomposition / Parallel Run
    // ============================
    DecompositionOptions { id: decompositionOptions }
    property Action openDecompositionOptions: Action {
        text: "Decomposition Options"
        tooltip: "Open decomposition options for a parallel run"
        iconSource: "images/decomposition.svg"
        iconName: text
        onTriggered: {
            leftOptionsSideBar.content = decompositionOptions
            leftOptionsSideBar.open()
        }
    }

    // External Tools
    // ==============
    property Action openParaview: Action {
        text: "Open Paraview"
        tooltip: text
        iconSource: "images/openParaview.svg"
        iconName: text
        onTriggered:  {
            app.call("open_paraview")
        }
    }


    // Treeview
    // =========
    property Action removeRefinementObject: Action {
        text: "Remove Refinement Object"
        tooltip: text
        iconName: text

        enabled: !!treeView && !!treeView.currentNode && treeView.currentNode.model.isRefinementObject
        onTriggered: app.call("remove_refinement_object", [treeView.currentNode.model.text, treeView.currentNode.model.type])
    }

    RenameDialog { id: renameDialog }
    property Action renameRefinementObject: Action {
        text: "Rename refinement object"
        tooltip: text
        iconName: text


        enabled: !!treeView && !!treeView.currentNode && treeView.currentNode.model.isRefinementObject
        onTriggered: {
            leftOptionsSideBar.content = renameDialog
            leftOptionsSideBar.open()
        }
    }


    // After Finish / With Result
    // ==========================
    property Action runCheckMesh: Action {
        text: "Run checkMesh utility"
        tooltip: text
        iconName: text
        iconSource: "images/checkMesh.svg"
        enabled: app.status === "finished"
        onTriggered: {
            app.call("run_check_mesh")
        }
    }

    property Action runRenumberMesh: Action {
        text: "Run renumberMesh utility"
        tooltip: text
        iconName: text

        enabled: app.status === "finished"
        onTriggered: {
            app.call("run_renumber_mesh")
        }
    }

    property Action clearMesh: Action {
        text: "Clear Mesh"
        tooltip: text
        iconName: text

        enabled: app.status === "finished"
        onTriggered: {
            app.call("clear_mesh")
        }
    }
}
