import QtQuick 2.4
import QtQml.Models 2.1
import QtGraphicalEffects 1.0

import DICE.Components 1.0
import DICE.Theme 1.0

Rectangle {
    id: root

    property int tabsBarHeight: 30
    property ListModel tabsModel

    width: parent.width
    height: tabsBarHeight
    color: "transparent"

    BottomBorder {}
    BottomShadow {}

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
            model: DelegateModel {
                id: visualModel

                model: tabsModel
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
                            color: delegateRoot.selected ? "#EEE" : "#f2f2f2"
                            gradient: Gradient {
                                GradientStop { color: delegateRoot.selected ? "#fafafa" : "#f4f4f4" ; position: 0 }
                                GradientStop { color: delegateRoot.selected ? "#EEE" : "#e4e4e4" ; position: 1 }
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
                            text: model.text
                            anchors.centerIn: parent
                            maximumLineCount: 1
                            elide: Text.ElideRight
                            width: parent.width - 20
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
                    }

                    DropArea {
                        anchors {
                            fill: parent
                        }
                        onEntered: {
                            visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
                            tabsModel.move(drag.source.visualIndex, delegateRoot.visualIndex, 1)
                            if (tabsModel.activeStreamItem === drag.source.visualIndex)
                                tabsModel.activeStreamItem = delegateRoot.visualIndex
                            else if (tabsModel.activeStreamItem === delegateRoot.visualIndex)
                                tabsModel.activeStreamItem = drag.source.visualIndex
                        }
                    }

                    onClicked: {
                        tabsListView.currentIndex = visualIndex
                    }
                    hoverEnabled: true
                    onEntered: hovered = true
                    onExited: hovered = false
                }
            }
        }
    }
}
