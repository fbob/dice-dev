import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import DICE.Components 1.0
import DICE.Theme 1.0

Rectangle {
    id: root
    // TODO: Header for the selected settingsTree item

    height: parent.height
    color: colors.mainBackgroundColor

    property string currentEditedNodePath: settingsTree.currentNodePath
    property string currentEditedLabel
    property string currentEditedText

    FileDialog {
        id: directoryDialog

        onAccepted: {
            var directoryPath = fileUrl.toString().substring(7) // remove "file://" from the url
            coreApp.setValue(currentEditedNodePath, currentEditedLabel, directoryPath)
            listView.model = coreApp.settingsList(settingsTree.currentNodePath)
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 5
        color: "#fff"
        border.color: colors.borderColor

        ColumnLayout {
            spacing: 0
            anchors.fill: parent

            MainHeader {
                Layout.fillWidth: true
                height: 50
                text: "Settings"
                z: 2
            }

            Item {
                width: 1
                height: 20
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ScrollView_DICE {
                    id: scrollView
                    anchors.fill: parent
                    anchors.margins: 25
                    z:1

                    ListView {
                        id: listView

                        model: coreApp.settingsList(settingsTree.currentNodePath)
                        width: scrollView.width

                        delegate: Row {
                            width: parent.width

                            InputField {
                                id: inputField

                                width: parent.width - button.width
                                label: modelData.label
                                text: modelData.value
                                onTextChanged: {
                                    coreApp.setValue(settingsTree.currentNodePath, label, text)
                                }
                            }
                            FlatButton {
                                id: button

                                width: 200
                                text: "Select"
                                onClicked:
                                {
                                    root.currentEditedLabel = inputField.label
                                    root.currentEditedText = inputField.text
                                    directoryDialog.open()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

