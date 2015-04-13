import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    width: 300
    height: 500

    Component {
        id: gettingStartedDelegate

        Rectangle {
            id: item

            property bool hovered: false

            width: ListView.view.width
            height: 60
            color: "#fff"

            Column {
                anchors.verticalCenter: parent.verticalCenter

                BasicText {
                    id: projectNameText

                    text: projectName
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pixelSize: 13
                }
                BasicText {
                    id: locationText

                    text: location
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    color: colors.borderColor
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
                cursorShape: Qt.PointingHandCursor
                onClicked: dice.loadProject(location)
            }

            states: [
                State {
                    name: "hovered"
                    when: item.hovered
                    PropertyChanges { target: item; color: "#4EA6EA" }
                    PropertyChanges { target: projectNameText; color: "white" }
                    PropertyChanges { target: locationText; color: "white" }
                }
            ]
            transitions: Transition {
                ColorAnimation { target:item; duration: 200 }
                ColorAnimation { target: projectNameText; duration: 100 }
                ColorAnimation { target: locationText; duration: 100 }
            }
        }
    }

    Component {
        id: headerDelegate

        Rectangle {
            width: ListView.view.width
            height: 30
            color: "#eee"

            BasicText {
                width: parent.width
                text: "Recent Projects"
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            BottomBorder {}
        }
    }

    Rectangle {
        width: parent.width - 20
        height: parent.height
        color: "#fff"
        border.color: colors.borderColor
        border.width: 1
        anchors {
            top: parent.top
            topMargin: 50
            right: parent.right
        }

        ScrollView_DICE {
            anchors.fill: parent
            ListView {
                id: gettingStartedList

                property var recentProjectsList: coreApp.recentProjects

                width: parent.width
                height: model.count*60

                model: ListModel {}
                delegate: gettingStartedDelegate
                header: headerDelegate

                onRecentProjectsListChanged: {
                    model.clear()
                    model.append(recentProjectsList)
                }
            }
        }
        TopBorder {}
        LeftBorder {}
        RightBorder {}
        BottomBorder {}
    }
}
