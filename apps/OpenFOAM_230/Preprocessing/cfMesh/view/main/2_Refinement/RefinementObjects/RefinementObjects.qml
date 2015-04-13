import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

Card {
    visible: !!treeView.currentNode && treeView.currentNode.model.isRefinementObject
    enabled: !!treeView.currentNode && treeView.currentNode.model.isRefinementObject

    Subheader { text: treeView.currentNode.model.text + " (" + treeView.currentNode.model.type +  ")" }

    Box {
        property bool isBox: treeView.currentNode.model.type === "box"

        visible: isBox
        enabled: isBox

        cellSize: "system/meshDict objectRefinements " + treeView.currentNode.text + " cellSize"
        centre: "system/meshDict objectRefinements " + treeView.currentNode.text + " centre"
        lengthX: "system/meshDict objectRefinements " + treeView.currentNode.text + " lengthX"
        lengthY: "system/meshDict objectRefinements " + treeView.currentNode.text + " lengthY"
        lengthZ: "system/meshDict objectRefinements " + treeView.currentNode.text + " lengthZ"
    }

    Sphere {
        property bool isSphere: treeView.currentNode.model.type === "sphere"

        visible: isSphere
        enabled: isSphere

        cellSize: "system/meshDict objectRefinements " + treeView.currentNode.text + " cellSize"
        centre: "system/meshDict objectRefinements " + treeView.currentNode.text + " centre"
        radius: "system/meshDict objectRefinements " + treeView.currentNode.text + " radius"
        refinementThickness: "system/meshDict objectRefinements " + treeView.currentNode.text + " refinementThickness"
    }

    Cone {
        property bool isCone: treeView.currentNode.model.type === "cone"

        visible: isCone
        enabled: isCone

        cellSize: "system/meshDict objectRefinements " + treeView.currentNode.text + " cellSize"
        p0: "system/meshDict objectRefinements " + treeView.currentNode.text + " p0"
        p1: "system/meshDict objectRefinements " + treeView.currentNode.text + " p1"
        radius0: "system/meshDict objectRefinements " + treeView.currentNode.text + " radius0"
        radius1: "system/meshDict objectRefinements " + treeView.currentNode.text + " radius1"
    }

    Line {
        property bool isLine: treeView.currentNode.model.type === "line"

        visible: isLine
        enabled: isLine

        cellSize: "system/meshDict objectRefinements " + treeView.currentNode.text + " cellSize"
        p0: "system/meshDict objectRefinements " + treeView.currentNode.text + " p0"
        p1: "system/meshDict objectRefinements " + treeView.currentNode.text + " p1"
        refinementThickness: "system/meshDict objectRefinements " + treeView.currentNode.text + " refinementThickness"
    }

    SurfaceMeshFile {
        property bool isSurfaceMeshFile: treeView.currentNode.model.type === "surface_mesh_file"

        visible: isSurfaceMeshFile
        additionalRefinementLevels: "system/meshDict surfaceMeshRefinement " + treeView.currentNode.text + " additionalRefinementLevels"
        refinementThickness: "system/meshDict surfaceMeshRefinement " + treeView.currentNode.text + " refinementThickness"
        cellSize: "system/meshDict surfaceMeshRefinement " + treeView.currentNode.text + " cellSize"
    }

    FlatButton {
        text: "Delete"
        onClicked: app.call("remove_refinement_object", [treeView.currentNode.model.text, treeView.currentNode.model.type])
    }
}

