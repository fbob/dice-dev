import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.Components 1.0
import DICE.Theme 1.0

import "TabBar"

Rectangle {
    id: root

    property bool minimized: false
    property int windowTabsHeight: 28
    property int windowControlsHeight: 120
    property var toolBarTabs: windowBarTabs

    width: parent.width
    height: windowControlsHeight
    color: colors.mainBackgroundColor
    clip: true

    TabViewDICE {
        id: windowBarTabs

        property bool tabRemoved: false

        width: parent.width
        implicitHeight: windowControlsHeight

        Tab {
            title: "Home"
            sourceComponent: !root.minimized ? mainWindow.home.toolBar : undefined
        }

        Tab {
            id: dynamicTab

            property var activeView: mainWindow.currentView
            property bool viewExists: !!activeView && !!activeView.title && !!activeView.toolBar

            title: (viewExists) ? activeView.title : ""
            sourceComponent: (viewExists && !root.minimized) ? activeView.toolBar : undefined

            onTitleChanged: {
                if(title !== "" && title !== "Home") {
                    windowBarTabs.currentIndex = windowBarTabs.count-1
                }
                else if (title === "Home")
                {
                    windowBarTabs.currentIndex = 0
                }
                else {
                    windowBarTabs.currentIndex = 0
                }
            }
        }

        style: tabViewStyle
    }

    Behavior on height { NumberAnimation { duration: 150 } }

    property int frameOverlapHeight : 0

    property Component tabViewStyle: TabViewDICEStyle {
        id: tabStyle
        tabOverlap: 0
        frameOverlap: frameOverlapHeight
        tabsMovable: false

        tabBar: Rectangle {
            color: colors.windowTabBarColor

            BottomShadow {}
            Rectangle {anchors.fill: parent; color: colors.windowTabBarColor }

            BottomBorder {
                visible: minimized
            }
            Rectangle {
                anchors.fill: parent
                color: {
                    var hours = parseInt(Qt.formatDateTime(new Date(), "hh"))
                    if (hours >= 0 && hours < 10)
                        return Qt.rgba(0,0,0,0)
                    if (hours >= 10 && hours < 16)
                        return Qt.rgba(0,0,0,0.3)
                    else
                        return Qt.rgba(0,0,0,0.5)
                }
            }
        }

        frame: Rectangle {
            anchors.fill: parent
            gradient: Gradient{
                GradientStop { color: Qt.lighter("#f1f1f1", 1) ; position: 0 }
                GradientStop { color: "#f1f1f1" ; position: 1 }
            }
            border.color: "#898989"
            Rectangle { anchors.fill: parent ; anchors.margins: 1 ; border.color: "#f4f4f4" ; color: "transparent" }
        }
        tab: Item {
            property int totalOverlap: tabOverlap * (control.count - 1)

            implicitWidth: {
                if (styleData.title === "" || (styleData.title === "Home" && styleData.index !== 0)) {
                    return 0
                }
                else {
                    return Math.min ((styleData.availableWidth + totalOverlap)/control.count - 4, tabLabel.paintedWidth + 35)

                }
            }
            implicitHeight: windowTabsHeight
            clip: true

            Rectangle {
                id: currentRect

                color: "transparent"
                width: parent.width
                height: parent.height
                BottomBorder{visible: styleData.selected; width: parent.width; color: colors.windowTabBarSelectedButtonText; height: 2.5}
            }

            ButtonText {
                id: tabLabel

                text: styleData.title
                anchors.centerIn: parent
                color: styleData.selected ? colors.windowTabBarSelectedButtonText : colors.windowTabBarTextColor
                font.letterSpacing: 1.5
            }

            BottomBorder{
                visible: styleData.hovered;
                width: parent.width/2;
                color: colors.windowTabBarSelectedButtonText;
                height: 1;
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        leftCorner: Rectangle {
            implicitWidth: 40
            implicitHeight: windowTabsHeight
            color: "transparent"
            y: -tabStyle.frameOverlap
            clip: true

            Rectangle {
                id: iconRect
                color: "transparent"
                height: parent.height - 5
                width: parent.height - 5
                anchors.centerIn: parent
                radius: 2
                border.color: colors.borderColor
                border.width: 0

                FontAwesomeIcon {
                    name: "Reorder"
                    color: colors.windowTabBarTextColor
                    size: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    diceMenu.__xOffset = -mouse.x
                    diceMenu.__yOffset = -mouse.y+parent.height
                    diceMenu.popup()
                }
                onEntered: {
                    iconRect.border.width = 1
                }
                onExited: {
                    iconRect.border.width = 0
                }
                WindowMenu {id: diceMenu}
            }
        }

        rightCorner: Item {
            id: minMaxWindowBar

            implicitWidth: 100
            implicitHeight: windowTabsHeight
            y: -tabStyle.frameOverlap

            Row {
                width: parent.width
                height: parent.height
                layoutDirection: Qt.RightToLeft

                Item {
                    property color iconHoverColor: colors.borderColor

                    width: 30
                    height: parent.height

                    FontAwesomeIcon {
                        name: "AngleUp"
                        color: parent.iconHoverColor
                        size: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !minimized
                    }

                    FontAwesomeIcon {
                        name: "AngleDown"
                        color: parent.iconHoverColor
                        size: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        visible: minimized
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            topMenuBar.toggleWindowBar()
                        }
                        onEntered: {
                            parent.iconHoverColor = "blue"
                        }
                        onExited:  {
                            parent.iconHoverColor = colors.borderColor
                        }
                    }
                }

                Item {
                    width: 30
                    height: parent.height
                }

                Rectangle {
                    property color iconHoverColor: colors.borderColor

                    width: 30
                    height: parent.height
                    color: "transparent"

                    FontAwesomeIcon {
                        name: "Off"
                        color: parent.iconHoverColor
                        size: parent.height/2.5
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.iconHoverColor = "#fff"
                            parent.color = "#CF5857"
                        }
                        onExited:  {
                            parent.iconHoverColor = colors.borderColor
                            parent.color = "transparent"
                        }
                        onClicked: actions.quitDiceAction.trigger()
                    }
                }
            }
        }
    }

    onHeightChanged: {
        if (height === windowTabsHeight) minimized = true
    }

    function toggleWindowBar () {
        if(topMenuBar.height === windowControlsHeight) {
            topMenuBar.height = windowTabsHeight - frameOverlapHeight
        }
        else {
            topMenuBar.height = windowControlsHeight
            minimized = false
        }
    }
}
