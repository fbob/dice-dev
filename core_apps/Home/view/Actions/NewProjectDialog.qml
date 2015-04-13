import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.3

import DICE.App 1.0

Component {
    Rectangle {
        id: newProjectDialog

        width: 290
        height: body.height

        property string projectDirectory: ""

        FileDialog {
            id: projectDirectoryDialog

            selectFolder: true
            onAccepted: {
                newProjectDialog.projectDirectory = fileUrl.toString().substring(7) // remove "file://" from the url
            }
        }

        Body {
            id: body
            width: parent.width
            Card {
                expanderVisible: false
                Subheader { text: "Create new Project" }
                InputField {
                    id: projectName
                    label: "Name of the Project"
                }
                Row {
                    height: 100
                    width: parent.width
                    InputField {
                        width: parent.width*2/3
                        anchors.verticalCenter: parent.verticalCenter
                        label: "Choose location"
                        text: projectDirectory
                        onTextChanged: {
                            projectDirectory = text
                        }
                    }
                    FlatButton {
                        width: parent.width/3
                        anchors.verticalCenter: parent.verticalCenter
                        text: "select"
                        onClicked: {
                            projectDirectoryDialog.open()
                        }
                    }
                }
                Caption { text: "Short description of the project" }
                TextArea {
                    id: descriptionEdit
                    width: parent.width
                    height: 150
                }
                Item {
                    height: 10
                    width: parent.width
                }
                Row {
                    spacing: 10
                    width: parent.width
                    FlatButton {
                        text: "Cancel"
                        width: (parent.width - parent.spacing)/2
                        onClicked: {
                            leftOptionsSideBar.close()
                        }
                    }
                    FlatButton {
                        text: "Create"
                        color: colors.highlightColor
                        textColor: "#fff"
                        width: (parent.width - parent.spacing)/2
                        onClicked: {
                            dice.createNewProject(projectName.text, projectDirectory, descriptionEdit.text)
                            leftOptionsSideBar.close()
                        }
                    }
                }
            }
        }
    }
}
