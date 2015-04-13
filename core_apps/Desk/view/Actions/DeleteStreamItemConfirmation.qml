import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

Component {
    Body {
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
                        customDialog.accept()
                        dice.desk.removeStreamItem(deskData.currentFocusedStreamItem.app)
                    }
                }
                FlatButton {
                    id: cancelButton

                    width: parent.width/2 - spacing/2
                    text: "No"
                    onClicked: {
                        customDialog.reject()
                    }
                }
            }
        }
//        Keys.onBackPressed: {
//            console.log("ENTER")
//            customDialog.accept()
//        }
//        Keys.onEscapePressed: {
//            console.log("ESC")
//            customDialog.reject()
//        }
    }
}
