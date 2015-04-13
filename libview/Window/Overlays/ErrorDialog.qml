import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2

import DICE.Theme 1.0
import DICE.Components 1.0


//MessageDialog {
//    id: errorDialog

//    title: "Error"
//    standardButtons: StandardButton.Ok
//    text: dice.error.type
//    detailedText: dice.error.msg
//    icon: StandardIcon.Critical

//    property Connections errorConn: Connections {
//        target: dice.error
//        onOccurred: {
//            errorDialog.open()
//        }
//    }
//}

Item {
    id: root

    FocusScope {
        id: errorDialogContent
        objectName: "ErrorDialog"

        property bool showing: false
        property int contentHeight
        property bool overlayOpen: appWindow.overlayLayer.overlayOpen

        opacity: 0
        width: 0
        height: 0

        onShowingChanged: {
            if (showing)
                appWindow.overlayLayer.overlayOpen = true
            else
                appWindow.overlayLayer.overlayOpen = false
        }

        onOverlayOpenChanged: {
            if (!overlayOpen) {
                closeCard()
            }
        }

        property Connections errorConn: Connections {
            target: dice.error
            onOccurred: {
                errorDialogContent.openCard()
                textArea.text = dice.error.msg
            }
        }

        state: showing ? "open" : "closed"

        states: [
            State {
                name: "closed"
                PropertyChanges {
                    target: errorDialogContent
                    opacity: 0
                    width: 0
                    height: 0
                }
            },
            State {
                name: "open"
                PropertyChanges {
                    target: errorDialogContent
                    opacity: 1
                    width: appWindow.overlayLayer.width/2
                    height: errorDialogContent.contentHeight
                }

                PropertyChanges {
                    target: content
                    opacity: 1
                    width: appWindow.overlayLayer.width/2
                    height: errorDialogContent.contentHeight
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "width, height, opacity"
                easing.type: Easing.InOutQuad
                duration: 300
            }
        }

        Timer {
            id: closeOverlay
            interval: 300
            onTriggered: {
                appWindow.overlayLayer.close()
                errorDialogContent.parent = root
            }
        }

        function openCard() {
            parent = appWindow.overlayLayer
            errorDialogContent.contentHeight = content.repeatHeightCalculation()
            appWindow.overlayLayer.overlayOpen = true
            errorDialogContent.anchors.centerIn = parent
            appWindow.overlayLayer.open()
            showing = true
            content.forceActiveFocus()
        }

        function closeCard() {
            showing = false
            parent = root
            closeOverlay.start()
        }


        Card {
            id: content
            expanderVisible: false

            opacity: 0
            width: 0
            height: 0

            Row {
                spacing: 10
                width: parent.width

                FontAwesomeIcon {
                    name: "WarningSign"
                    color: colors.warningColor
                }

                SubheaderText {
                    width: 250
                    text: "Error: " + dice.error.type
                }
            }

            Rectangle {
                width: parent.width
                height: 2
                color: colors.warningColor
            }

            TextArea {
                id: textArea

                width: parent.width
                readOnly: true
            }

            FlatButton {
                width: parent.width
                text: "Close"
                onClicked: {
                    errorDialogContent.closeCard()
                }
            }

            transitions: Transition {
                NumberAnimation {
                    properties: "width, height, opacity"
                    easing.type: Easing.InOutQuad
                    duration: 300
                }
            }

            Keys.onEscapePressed: errorDialogContent.closeCard()
        }
    }
}
