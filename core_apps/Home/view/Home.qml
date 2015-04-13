import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

import "Menus"
import "Actions"

CoreApp {
    id: root

    title: "Home"
    toolBar: ToolBar {}

    // Exporting the actions of Home for other CoreApps, e.g. Desk.
    // Always use the exact same two lines.
    Actions { id: actions }
    actions: actions

    header: Rectangle {
        id: welcomeHeader

        height: 50
        color: "#fff"

        BottomBorder {}

        RoundActionButton {
            width: 100
            height: 100
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 20
                topMargin: 10
            }
            z: 999
        }

        Item {
            id: headlineBox
            width: headlineText.implicitWidth
            height: parent.height
            anchors {
                left: parent.left
                leftMargin: 120
            }
            HeadlineText {
                id: headlineText
                text: "Welcome to the <b>D</b>ynamic <b>I</b>nterface for <b>C</b>omputation and <b>E</b>valuation"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                color: "#666"
            }
        }
    }

    background: Column {
        Row {
            height: parent.height //- welcomeHeader.height
            width: parent.width
            Rectangle {
                id: leftSide
                width: 60
                height: parent.height
                color: "#eee"
                RightBorder {}
            }
            Rectangle {
                width: parent.width - leftSide.width
                height: parent.height
                color: colors.mainBackgroundColor
            }
        }
    }

    ScrollView_DICE {
        id: scrollView
        anchors.fill: parent

        Item {
            id: mainContent

            width: row.width + row.anchors.leftMargin
            height: row.height + row.anchors.topMargin + 100

            Row {
                id: row

                height: childrenRect.height
                anchors.left: parent.left
                anchors.leftMargin: 60
                anchors.top: parent.top
                anchors.topMargin: 50

                RecentProjects {}
                GettingStarted {}
            }
        }
    }
}
