import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2

import DICE.App 1.0

Dialog {
    id: root
    title: "Confirmation"

    Loader {
        id: itemLoader

        visible: false
        sourceComponent: Body {
            width: 300
            Card {
                expanderVisible: false
                BodyText {
                    text: "Do you really want to delete the selected StreamItem?"
                    horizontalAlignment: Text.AlignHCenter
                }
                Item {
                    height: 20
                    width: 1
                }
                Row {
                    width: parent.width
                    spacing: 10

                    FlatButton {
                        id: confirmButton

                        width: parent.width/2 - spacing/2
                        text: "Yes"
                        onClicked: {
                            root.accept()
                        }
                    }
                    FlatButton {
                        id: cancelButton

                        width: parent.width/2 - spacing/2
                        text: "No"
                        onClicked: {
                            root.reject()
                        }
                    }
                }
            }
            Keys.onReturnPressed: {
                confirmButton.clicked()
            }
            Keys.onEscapePressed: {
                cancelButton.clicked()
            }
        }
    }

    onAccepted: dice.desk.removeStreamItem(deskData.currentFocusedStreamItem.app)
    contentItem: itemLoader.item
    modality: Qt.WindowModal
}
