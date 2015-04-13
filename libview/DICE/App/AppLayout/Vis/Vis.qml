import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import DICE.Components 1.0
import DICE.App.Renderer 1.0
import DICE.App 1.0

Column {
    anchors.fill: parent

// TODO: Seperate geometry and mesh view
//    TabsBar {
//        id: tabsBar

//        width: parent.width
//        height: 30

//        tabsModel: ListModel {
//            ListElement {
//                text: "Geometry"
//            }
//            ListElement {
//                text: "Mesh"
//            }
//        }
//    }

    Rectangle {
        id: root

        property bool loading: renderer.renderer.loading
        property bool autoLoad: true // set to true if the geometries should be loaded immediately
        property var pickedPatch

        width: parent.width
        height: parent.height

        Rectangle {
            id: rendererBackground

            anchors.fill: parent
            color: "#eee"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#EEE"; }
                GradientStop { position: 0.8; color: "#E9E9E9"; }
                GradientStop { position: 1.0; color: "#C0C0C0"; }
            }
        }

        onLoadingChanged: {
            console.log("renderer loading: "+loading)
        }

        Binding {
            target: renderer.renderer
            property: "visObjects"
            value: app.visObjects
        }

        Component.onCompleted: {
            app.setCallback("reloadRenderer", function() {
                renderer.renderer.reload()
            })
        }

        function resetCamera() {
            renderer.renderer.resetCamera()
        }

        onVisibleChanged: {
            if (renderer.visible)
                renderer.loader.enabled = false
            renderer.loader.enabled = true
        }

        Renderer {
            id: renderer
            visApp: app
        }

        TreeView {
            id: geometriesTreeView

            maxHeight: 400
            width: 200
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: {top: 5; left: 5}
            model: ListModel {}
            onCurrentNodePathChanged: {
                app.selectedVisObjectPath = currentNodePath
            }

            property var objectsTree: app.visObjectsTree
            onObjectsTreeChanged: {
                model.clear()
                model.append(objectsTree)
            }
            rightInfo: Item {
                width: 10
                height: 10
                visible: !!model.object

                IconCheckBox {
                    size: 15
                    anchors.centerIn: parent
                    checked: model.object.visible
                    onClicked: model.object.visible = checked
                    awesomeIconName: checked ? "EyeOpen" : "EyeClose"
                }
            }
        }
        Connections {
            target: renderer.renderer
            onPickedPatchChanged: {
                root.pickedPatch = renderer.renderer.pickedPatch
                geometriesTreeView.setCurrentNode(root.pickedPatch)
            }
        }
        onPickedPatchChanged: renderer.renderer.pickedPatch = pickedPatch
    }
}
