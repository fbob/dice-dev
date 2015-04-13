import QtQuick 2.4
import QtQml.Models 2.1
import QtGraphicalEffects 1.0

import DICE.Components 1.0
import DICE.Theme 1.0

Rectangle {
    id: root

    property int tabsBarHeight: 30
    property ListModel openedStreamItems

    width: parent.width
    height: tabsBarHeight
    color: "#eee"


    BottomBorder {}
    BottomShadow {}
    TopShadow {}

    Row {
        width: parent.width
        height: parent.height
        spacing: 0
        Item {
            id: leftSpace
            width: mainNavi.width
            height: parent.height
        }
        ListView {
            id: tabsListView

            width: parent.width - leftSpace.width
            height: parent.height - 2
            anchors.bottom: parent.bottom
            orientation: Qt.LeftToRight
            interactive: false
            displaced: Transition {
                NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
            }
            currentIndex: openedStreamItems.activeStreamItem
            model: DelegateModel {
                id: visualModel

                model: openedStreamItems
                delegate: MouseArea {
                    id: delegateRoot

                    property int visualIndex: DelegateModel.itemsIndex
                    property bool selected: tabsListView.currentIndex === visualIndex
                    property bool hovered: false
                    property int availableWidth: tabsListView.width

                    implicitWidth: Math.min(delegateRoot.availableWidth/tabsListView.count, 200)
                    implicitHeight: 28
                    drag.target: tab
                    anchors.bottom: parent.bottom

                    Rectangle {
                        id: tab
                        width: Math.min(delegateRoot.availableWidth/tabsListView.count, 200)
                        height: parent.height

                        color: "transparent"

                        RectangularGlow {
                            width: parent.width
                            height: parent.height
                            glowRadius: 3
                            spread: 0.2
                            color: "#d2d2d2"
                            cornerRadius: 5
                            anchors.left: parent.left
                            anchors.leftMargin: -1
                            anchors.right: parent.right
                            anchors.rightMargin: -1
                            visible: delegateRoot.selected
                        }

                        Rectangle {
                            id: background
                            anchors.fill: parent
                            color: delegateRoot.selected ? "#f4f4f4" : "#f2f2f2"
                            gradient: Gradient {
                                GradientStop { color: delegateRoot.selected ? "#fafafa" : "#eee" ; position: 0 }
                                GradientStop { color: delegateRoot.selected ? "#f4f4f4" : "#e4e4e4" ; position: 1 }
                            }
                            TopBorder {}
                            RightBorder {}
                            LeftBorder {}
                            BottomBorder { visible: !delegateRoot.selected }
                        }

                        anchors {
                            horizontalCenter: parent.horizontalCenter;
                            bottom: parent.bottom
                        }

                        MenuText {
                            text: model.streamItem.instanceName
                            anchors.centerIn: parent
                            maximumLineCount: 1
                            elide: Text.ElideRight
                            width: parent.width - removeButton.width - 20
                            scalablePixelSize: 14
                            color: "#444"
                            font.family: fonts.codeTextFont
                        }

                        Drag.active: delegateRoot.drag.active
                        Drag.source: delegateRoot
                        Drag.hotSpot.x: 20
                        Drag.hotSpot.y: 20

                        states: [
                            State {
                                when: tab.Drag.active
                                ParentChange {
                                    target: tab
                                    parent: tabsListView
                                }
                                AnchorChanges {
                                    target: tab;
                                    anchors.horizontalCenter: undefined;
                                    anchors.verticalCenter: undefined
                                }
                            },
                            State {
                                when: delegateRoot.hovered
                                PropertyChanges {
                                    target: tab
                                    opacity: 1
                                }
                            }

                        ]

                        Rectangle {
                            id: removeButton
                            width: 25
                            height: parent.height
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.rightMargin: 5

                            Rectangle {
                                id: closeButton

                                anchors.centerIn: parent
                                width: parent.width*0.6
                                height: parent.width*0.6
                                radius: height/2
                                anchors.verticalCenterOffset: 2
                                color: "transparent"
                                Image {
                                    id: closeImage
                                    source: "images/close.svg"
                                    anchors.centerIn: parent
                                    sourceSize.height: parent.height*0.8
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: dice.desk.closeStreamItem(model.streamItem)
                                    onEntered: {
                                        closeImage.source = "images/close_red.svg"
                                    }
                                    onExited: {
                                        closeImage.source = "images/close.svg"
                                    }
                                }
                            }
                        }
                    }

                    DropArea {
                        anchors {
                            fill: parent
                        }
                        onEntered: {
                            visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
                            openedStreamItems.move(drag.source.visualIndex, delegateRoot.visualIndex, 1)
                            if (openedStreamItems.activeStreamItem === drag.source.visualIndex)
                                openedStreamItems.activeStreamItem = delegateRoot.visualIndex
                            else if (openedStreamItems.activeStreamItem === delegateRoot.visualIndex)
                                openedStreamItems.activeStreamItem = drag.source.visualIndex
                        }
                    }

                    onClicked: {
                        openedStreamItems.activeStreamItem = visualIndex
                    }
                    hoverEnabled: true
                    onEntered: hovered = true
                    onExited: hovered = false
                }
            }
        }
    }
}
