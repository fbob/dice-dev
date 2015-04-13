import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Features Refinement"

    enabled: !!treeView.currentNode && !treeView.currentNode.model.isRegion
    visibleShadowAndBorder: false
    expanderVisible: false

    FoamDictCheck {
        id: snappyFeatureDict

        property string fileIndex
        property var currentNode: treeView.currentNode

        path: "system/snappyHexMeshDict castellatedMeshControls features " + fileIndex + " file"

        onCurrentNodeChanged: {
            getFileIndex()
        }
        function getFileIndex(){
            app.call("get_file_index", [treeView.currentNodePath[0]], function(returnValue){fileIndex = returnValue})
        }
    }

    Repeater {
        id: featureLevels

        model: PythonListModel {
            loadMethod: "get_feature_levels_list_length"
            loadParameters: [snappyFeatureDict.fileIndex]
            changedCallback: "featureLevelsListChanged"
        }
        delegate: Row {
            spacing: 10
            width: parent.width
            visible: snappyFeatureDict.exists
            enabled: !treeView.currentNode.model.isRegion && snappyFeatureDict.exists

            FoamVector2D {
                width: (parent.width - parent.spacing)*0.9
                xLabel: "Distance [m]"
                yLabel: "Level"
                xDataType: "double"
                yDataType: "int"
                path: "system/snappyHexMeshDict castellatedMeshControls features " + snappyFeatureDict.fileIndex + " levels " + index
            }
            FlatButton {
                text: "-"
                visible: index !== 0
                width: (parent.width - parent.spacing)*0.1
                onClicked: {
                    app.call("remove_feature_level", [snappyFeatureDict.fileIndex, index, treeView.currentNodePath[0]])
//                    featureLevelsListChanged()
                }
            }
        }
    }
    FlatButton {
        text: "Add level"
        visible: snappyFeatureDict.exists
        width: parent.width
        onClicked: {
            app.call("add_feature_level", [snappyFeatureDict.fileIndex, featureLevels.count])
//            featureLevelsListChanged()
        }
    }

    FoamValue {
        label: "includedAngle"
        enabled: snappyFeatureDict.exists
        visible: enabled
        path: "system/surfaceFeatureExtractDict " + treeView.currentNodePath[0]  + " extractFromSurfaceCoeffs includedAngle"
    }
    FoamDropDown {
        label: "extractionMethod"
        enabled: snappyFeatureDict.exists
        visible: enabled
        path: "system/surfaceFeatureExtractDict " + treeView.currentNodePath[0]  + " extractionMethod"
        modelPath: "surfaceFeatureExtractDict extractionMethod"
    }
    FoamToggleButton {
        label: "writeObj"
        enabled: snappyFeatureDict.exists
        visible: enabled
        uncheckedText: "no"
        checkedText: "yes"
        path: "system/surfaceFeatureExtractDict " + treeView.currentNodePath[0]  + " writeObj"
    }

    //TODO: Add subsetFeatures objects: insideBox, plane, ...
    FoamToggleButton {
        label: "nonManifoldEdges"
        enabled: snappyFeatureDict.exists
        visible: enabled
        uncheckedText: "no"
        checkedText: "yes"
        path: "system/surfaceFeatureExtractDict " + treeView.currentNodePath[0]  + " subsetFeatures nonManifoldEdges"
    }
    FoamToggleButton {
        label: "openEdges"
        enabled: snappyFeatureDict.exists
        visible: enabled
        uncheckedText: "no"
        checkedText: "yes"
        path: "system/surfaceFeatureExtractDict " + treeView.currentNodePath[0]  + " subsetFeatures openEdges"
    }

    Row {
        width: parent.width
        spacing: 10

        FlatButton {
            width: (parent.width - parent.spacing)/2
            text: "Add Feature"
            enabled: !snappyFeatureDict.exists
            onClicked: {
                app.call("add_feature", [treeView.currentNodePath[0]])
                snappyFeatureDict.getFileIndex()
                snappyFeatureDict.checkIfDictExists()
            }
        }
        FlatButton {
            width: (parent.width - parent.spacing)/2
            enabled: snappyFeatureDict.exists
            text: "Delete Feature"
            onClicked: {
                app.call("remove_feature", [treeView.currentNodePath[0]])
                snappyFeatureDict.exists = false
            }
        }
    }
}

