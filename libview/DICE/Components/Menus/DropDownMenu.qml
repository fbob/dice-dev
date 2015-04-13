import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.Components 1.0
import DICE.Theme 1.0

FlatButton {
    id: root

    default property alias children: content.children
    property int contentWidth: width

    onClicked: {
        menuContent.openCard()
    }

    FocusScope {
        id: menuContent
        objectName: "DropDownMenu"

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
            if (!overlayOpen)
                closeCard()
        }

        state: showing ? "open" : "closed"

        states: [
            State {
                name: "closed"
                PropertyChanges {
                    target: menuContent
                    opacity: 0
                    width: 0
                    height: 0
                }
            },
            State {
                name: "open"
                PropertyChanges {
                    target: menuContent
                    opacity: 1
                    width: root.contentWidth
                    height: menuContent.contentHeight
                }

                PropertyChanges {
                    target: content
                    opacity: 1
                    width: root.contentWidth
                    height: menuContent.contentHeight
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
                menuContent.parent = root
            }
        }

        function openCard() {
            parent = appWindow.overlayLayer
            menuContent.contentHeight = content.repeatHeightCalculation()
            appWindow.overlayLayer.overlayOpen = true
            var position = root.mapToItem(appWindow.overlayLayer, 0, 0)
            menuContent.x = position.x
            menuContent.y = position.y
            appWindow.overlayLayer.open()
            showing = true
            content.forceActiveFocus()
        }

        function closeCard() {
            showing = false
            closeOverlay.start()
        }


        Card {
            id: content
            expanderVisible: false

            opacity: 0
            width: 0
            height: 0

            transitions: Transition {
                NumberAnimation {
                    properties: "width, height, opacity"
                    easing.type: Easing.InOutQuad
                    duration: 300
                }
            }

            Keys.onEscapePressed: menuContent.closeCard()
        }
    }
}

