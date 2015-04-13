import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    width: 600
    height: 500

    Component {
        id: gettingStartedDelegate

        Item {
            id: margins

            width: ListView.view.width
            height: 60

            Rectangle {
                id: item

                property bool hovered: false

                width: parent.width - 40
                height: parent.height
                anchors.centerIn: parent
                color: "transparent" // keep as Rectangle, the color is manipulated later
                border.width: 0
                border.color: colors.borderColor
                radius: 2

                Row {
                    width: parent.width
                    height: parent.height
                    spacing: 10

                    Item {
                        width: 20
                        height: parent.height
                    }
                    Image {
                        id: icon

                        sourceSize.width: parent.height - 25
                        sourceSize.height: parent.height - 25
                        anchors.verticalCenter: parent.verticalCenter
                        source: iconSrc
                    }
                    BasicText {
                        id: listItemText

                        text: listItem
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 13
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        item.hovered = !item.hovered
                    }
                    onExited: {
                       item.hovered = !item.hovered
                    }
                    onClicked: {
                        switch (index) {
                        case 0:
                            actions.createNewProjectAction.trigger()
                            break
                        case 1:
                            actions.loadProjectAction.trigger()
                            break
                        case 2:
                            mainNavi.gotoCoreApp("Desk")
                            break
                        case 3:
                            mainNavi.gotoCoreApp("Settings")
                            break
                        }
                    }
                }
                states: [
                    State {
                        name: "hovered"
                        when: item.hovered
                        PropertyChanges { target: item; color: "#fff" ; border.width:1 }
                    }
                ]
            }
        }
    }

    Component {
        id: headerDelegate

        Item {
            width: ListView.view.width
            height: 50

            Rectangle {
                width: parent.width
                height: parent.height - 20
                color: "#eee"
                anchors.top: parent.top

                BasicText {
                    width: parent.width
                    text: "Getting Started"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                BottomBorder {}
            }
        }
    }

    Rectangle {
        width: parent.width - 10
        height: parent.height
        color: "#f2f2f2"
        border.color: colors.borderColor
        border.width: 1
        anchors {
            top: parent.top
            topMargin: 50
            horizontalCenter: parent.horizontalCenter
        }

        ListView {
            id: gettingStartedList

            width: parent.width
            height: parent.height
            model: ListModel {
                ListElement {
                    listItem: "Create New Project"
                    iconSrc: "images/create_new_project.svg"
                }
                ListElement {
                    listItem: "Open Existing Project"
                    iconSrc: "images/load_project.svg"
                }
                ListElement {
                    listItem: "Open Desk"
                    iconSrc: "images/desk_icon.svg"
                }
                ListElement {
                    listItem: "Settings"
                    iconSrc: "images/settings.svg"
                }
            }
            delegate: gettingStartedDelegate
            header: headerDelegate
            interactive: false
        }

        TopBorder {}
        LeftBorder {}
        RightBorder {}
        BottomBorder {}
    }
}
