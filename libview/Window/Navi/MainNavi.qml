import QtQuick 2.4

import DICE.Components 1.0

Rectangle {
    id: root

    property int defaultNaviWidth: 110
    property int minimizedNaviWidth: 40
    property alias currentIndex: navi.currentIndex

    function incrementCurrentIndex() { navi.incrementCurrentIndex() }
    function decrementCurrentIndex() { navi.decrementCurrentIndex() }

    width: defaultNaviWidth
    height: appWindow.height - toolBar.height - tabsBar.height
    anchors.top: tabsBar.bottom

    color: colors.mainNaviShadowColor

    RightShadow {}

    Rectangle {
        anchors.fill: parent
        anchors.rightMargin: 2
        color: colors.mainNaviBackgroundColor
    }

    Component {
        id: highlight
        Item {
            width: root.width; height: 40
            y: navi.currentItem.y

            Behavior on y {
                SpringAnimation {
                    spring: 2
                    damping: 0.3
                }
            }

            LeftBorder { color: colors.highlightColor; width: 2 }

            Rectangle {
                height: 30
                color: "transparent"
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                radius: 10
            }
        }
    }

    ScrollView_DICE {
        id: scrollView
        anchors.fill: parent

        ListView {
            id: navi
            width: scrollView.width
            model: dice.coreApps

            delegate: NaviButton {}
            interactive: false
            highlight: highlight

            section.property: "type"
            section.criteria: ViewSection.FullString
            section.delegate: sectionHeading
        }
    }

    // The delegate for each section header
    Component {
        id: sectionHeading
        Item {
            width: parent.width
            height: 20

            // Divider
            Item {
                height: 10
                width: parent.width - 30
                anchors.horizontalCenter: parent.horizontalCenter
                BottomBorder{ color: Qt.darker(colors.borderColor, 5); anchors.bottomMargin: 0}
                opacity: 0.1
            }
        }
    }

    Rectangle {
        id: minMaxNavi
        width: parent.width
        height: 50
        color: "transparent"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        Image {
            sourceSize.width: parent.width
            source: "images/dice_logo_darkGrey.svg"
            anchors.centerIn: parent
            scale: 0.3

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: cursorShape = Qt.PointingHandCursor
                onClicked: {
                    toggleWidthNavi()
                }
            }
        }

        PropertyAnimation {
            id: animationToMin;
            target: mainNavi;
            property: "width";
            to: root.minimizedNaviWidth;
            duration: 150
        }

        PropertyAnimation {
            id: animationToMax;
            target: mainNavi;
            property: "width";
            to: root.defaultNaviWidth;
            duration: 150
        }
    }

    function toggleWidthNavi(){
        if(mainNavi.width == root.defaultNaviWidth) {
            animationToMin.running = true
        }
        else {
            animationToMax.running = true
        }
    }

    function gotoCoreApp(title) {
        for (var i=0; i<dice.coreApps.count; i++) {
            var coreApp = dice.coreApps.get(i)
            if (coreApp.name === title) {
                currentIndex = i
                mainWindow.hideApp()
                break
            }
        }
    }
}
