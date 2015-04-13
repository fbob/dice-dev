import QtQuick 2.4

import DICE.App 1.0

Card {
    enabled: !!treeView.currentNode && treeView.currentNode.model.isRefinementObject
    visible: !!treeView.currentNode && treeView.currentNode.model.isRefinementObject

    Subheader { text: treeView.currentNode.model.text + " (" + treeView.currentNode.model.type +  ")" }

    SearchableBox {
        property bool isSearchableBox: treeView.currentNode.model.type === "searchableBox"

        enabled: isSearchableBox
        visible: enabled

        min_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " min"
        max_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " max"
    }
    SearchableSphere {
        property bool isSearchableSphere: treeView.currentNode.model.type === "searchableSphere"

        enabled: isSearchableSphere
        visible: enabled

        centre_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " centre"
        radius_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " radius"
    }
    SearchableCylinder {
        property bool isSearchableCylinder: treeView.currentNode.model.type === "searchableCylinder"

        enabled: isSearchableCylinder
        visible: enabled

        point_1_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " point1"
        point_2_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " point2"
        radius_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " radius"
    }
    SearchablePlate {
        property bool isSearchablePlate: treeView.currentNode.model.type === "searchablePlate"

        enabled: isSearchablePlate
        visible: enabled

        origin_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " origin"
        span_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " span"
    }
    SearchablePlane_PointAndNormal {
        property bool isSearchablePlane_PointAndNormal: treeView.currentNode.model.type === "searchablePlanePaN"

        enabled: isSearchablePlane_PointAndNormal
        visible: enabled

        basePoint_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " pointAndNormalDict basePoint"
        normalVector_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " pointAndNormalDict normalVector"
    }
    SearchablePlane_3Points {
        property bool isSearchablePlane_3Points: treeView.currentNode.model.type === "searchablePlane3P"

        enabled: isSearchablePlane_3Points
        visible: enabled

        point1_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " embeddedPointsDict point1"
        point2_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " embeddedPointsDict point2"
        point3_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " embeddedPointsDict point3"
    }
    SearchableDisk {
        property bool isSearchableDisk: treeView.currentNode.model.type === "searchableDisk"

        enabled: isSearchableDisk
        visible: enabled

        origin_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " origin"
        normal_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " normal"
        radius_path: "system/snappyHexMeshDict geometry " + treeView.currentNode.text + " radius"
    }

    FlatButton {
        text: "Delete"
        onClicked: {
            app.call("remove_refinement_object", [treeView.currentNodePath[0]])
        }
    }
}

