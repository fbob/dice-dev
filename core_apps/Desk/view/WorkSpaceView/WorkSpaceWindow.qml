import QtQuick 2.4

import DICE.Components 1.0

Item {
    id: root

    property alias workSpaceScrollView: workSpaceScrollView
    property alias workSpace: workSpace

    Rectangle {
        id: workSpaceBackground
        width: parent.width
        height: parent.height
        color: "#eee"
        opacity: 0.2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#C0C0C0"; }
            GradientStop { position: 0.9; color: "#767676"; }
            GradientStop { position: 1.0; color: "#C0C0C0"; }
        }
    }

    ScrollView_DICE {
        id: workSpaceScrollView
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOn
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn

        WorkSpace {
            id: workSpace
        }
    }
}
