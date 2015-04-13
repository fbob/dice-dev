import QtQuick 2.4
import QtQuick.Controls 1.3

Item {
    property var treeView: appRoot.contentItems["Import"].treeView

    property Action surfaceCheck: Action {
        text: "surfaceCheck"
        shortcut: ""
        tooltip: "Checking geometric and topological quality of a surface."
        iconSource: "images/surfaceCheck.svg"
        iconName: "Run " + app.name
        enabled: treeView.currentNodePath !== undefined
        onTriggered: {
            app.call("surface_check", [treeView.currentNodePath[0]])
        }
    }

    SurfaceOrient {id: so}
    property Action surfaceOrient: Action {
        text: "surfaceOrient"
        shortcut: ""
        tooltip: "Set normal consistent with respect to a user provided ’outside’ point. If the -inside is used the point is considered inside."
        iconSource: "images/surfaceOrient.svg"
        iconName: text
        enabled: treeView.currentNodePath !== undefined
        onTriggered: {
            leftOptionsSideBar.content = so
            leftOptionsSideBar.open()
        }
    }

    SurfaceTransformPoints {id: stp}
    property Action surfaceTransformPoints: Action {
        text: "surfaceTransform"
        shortcut: "Transform (scale/rotate) a surface. Like transformPoints but for surfaces."
        tooltip: text
        iconSource: "images/surfaceTransformPoints.svg"
        iconName: text
        enabled: treeView.currentNodePath !== undefined
        onTriggered: {
            leftOptionsSideBar.content = stp
            leftOptionsSideBar.open()
        }
    }

    SurfaceAutoPatch {id: sap}
    property Action surfaceAutoPatch: Action {
        text: "surfaceAutoPatch"
        shortcut: ""
        tooltip: text
        iconSource: "images/surfaceAutoPatch.svg"
        iconName: text
        enabled: treeView.currentNodePath !== undefined
        onTriggered: {
            leftOptionsSideBar.content = sap
            leftOptionsSideBar.open()
        }
    }
    property Action surfaceMeshInfo: Action {
        text: "surfaceMeshInfo"
        shortcut: ""
        tooltip: "Miscellaneous information about surface meshes."
        iconSource: "images/surfaceMeshInfo.svg"
        enabled: treeView.currentNodePath !== undefined
        iconName: text
        onTriggered: {
            app.call("surface_mesh_info", [treeView.currentNodePath[0]])
        }
    }
    property Action surfaceSplitByPatch: Action {
        text: "surfaceSplitByPatch"
        shortcut: ""
        tooltip: "Writes regions of triSurface to separate files."
        iconSource: "images/surfaceSplitByPatch.svg"
        enabled: treeView.currentNodePath !== undefined
        iconName: text
        onTriggered: {
            app.call("surface_split_by_patch", [treeView.currentNodePath[0]])
        }
    }
    property Action surfaceRefineRedGreen: Action {
        text: "surfaceRefineRedGreen"
        shortcut: ""
        tooltip: "Refine by splitting all three edges of triangle (’red’ refinement). Neighbouring triangles (which are not marked for refinement get split in half (’green’ refinement). (R. Verfuerth, ”A review of a posteriori error estimation and adaptive mesh refinement techniques”, Wiley-Teubner, 1996) "
        iconSource: "images/surfaceRefineRedGreen.svg"
        enabled: treeView.currentNodePath !== undefined
        iconName: text
        onTriggered: {
            app.call("surface_refine_red_green", [treeView.currentNodePath[0]])
        }
    }

    SurfaceCoarsen {id: sc}
    property Action surfaceCoarsen: Action {
        text: "surfaceCoarsen"
        shortcut: ""
        tooltip: "Surface coarsening using ’bunnylod’."
        iconSource: "images/surfaceCoarsen.svg"
        enabled: treeView.currentNodePath !== undefined
        iconName: text
        onTriggered: {
            leftOptionsSideBar.content = sc
            leftOptionsSideBar.open()
        }
    }

    property Action openParaview: Action {
        text: "Open Paraview"
        tooltip: text
        iconSource: "images/openParaview.svg"
        iconName: text
        onTriggered:  {
            app.call("open_paraview")
        }
    }
}
