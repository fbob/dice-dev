import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

MainHeader {
    id: root

    DropDown {
        id: representationComboBox

        width: 150
        anchors.verticalCenter: parent.verticalCenter
        model: ListModel {
            ListElement {
                text: "Surface"
            }
            ListElement {
                text: "Surface with edges"
            }
            ListElement {
                text: "Wireframe"
            }
            ListElement {
                text: "Points"
            }
        }
        onCurrentIndexChanged: {
            if (!app.selectedVisObject) return

            switch (currentIndex) {
            case 0:
                app.selectedVisObject.representation = "Surface"
                break
            case 1:
                app.selectedVisObject.representation = "SurfaceWithEdges"
                break
            case 2:
                app.selectedVisObject.representation = "Wireframe"
                break
            case 3:
                app.selectedVisObject.representation = "Points"
                break
            }
        }

        function setCurrentRepresentation(representation) {
            switch (representation) {
            case "Surface":
                currentIndex = 0
                break
            case "SurfaceWithEdges":
                currentIndex = 1
                break
            case "Wireframe":
                currentIndex = 2
                break
            case "Points":
                currentIndex = 3
                break
            }
        }

        Connections {
            target: app
            onSelectedVisObjectChanged: {
                representationComboBox.setCurrentRepresentation(app.selectedVisObject.representation)
            }
        }
    }

    IconCheckBox {
        checked: !!app.selectedVisObject ? app.selectedVisObject.visible : false
        enabled: !!app.selectedVisObject
        onClicked: app.selectedVisObject.visible = checked
        awesomeIconName: !!app.selectedVisObject && app.selectedVisObject.visible ? "EyeOpen" : "EyeClose"
        anchors.verticalCenter: parent.verticalCenter
    }

    DropDownMenu {
        awesomeIconName: "CameraRetro"
        contentWidth: 150

        Subheader { text: "View" }

        FlatButton {
            text: "+X"
            onClicked: {
                app.camera.align("+x")
            }
        }
        FlatButton {
            text: "-X"
            onClicked: {
                app.camera.align("-x")
            }
        }
        FlatButton {
            text: "+Y"
            onClicked: {
                app.camera.align("+y")
            }
        }
        FlatButton {
            text: "-Y"
            onClicked: {
                app.camera.align("-y")
            }
        }
        FlatButton {
            text: "+Z"
            onClicked: {
                app.camera.align("+z")
            }
        }
        FlatButton {
            text: "-Z"
            onClicked: {
                app.camera.align("-z")
            }
        }
        ToggleButton {
            label: "Parallel Projection"
            checked: app.camera.parallelProjection
            onCheckedChanged: app.camera.parallelProjection = checked
        }
    }

    FlatButton {
        text: "Reset"
        width: 50
        onClicked: app.camera.resetCamera()
    }
}
