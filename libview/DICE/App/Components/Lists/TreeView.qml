import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3

import DICE.Components 1.0
import DICE.Theme 1.0

ScrollView_DICE {
    id: root

    property ListModel model: ListModel {}
    property var currentNodePath: undefined
    property int rowHeight: 20
    property int columnIndent: 28
    property var currentNode: undefined
    property var currentItem
    readonly property int contentHeight: contentItem.height
    property int maxHeight: 150
    property var modelData
    property var menu
    property Component rightInfo

    onModelDataChanged: {
        model.clear()
        model.append(modelData)
        currentNodePath = undefined
    }

    signal newCurrentNode(var nodePath)

    height: Math.min(maxHeight, contentHeight)
    implicitWidth: 200
    implicitHeight: 160

    function setCurrentNode(path) {
        newCurrentNode(path)
    }

    property Component folderIconDelegate: Item {
        width: icon.size + 10
        height: rowHeight
        FontAwesomeIcon {
            id: icon

            icon: loaderExpanded ? FontAwesome.Icon.FolderOpen : FontAwesome.Icon.FolderClose
            color: "#333"
            size: 12
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            visible: !!model.elements
        }
    }

    property Component fileIconDelegate: Item {
        width: rowHeight
        height: rowHeight

        FontAwesomeIcon {
            name: "File"
            color: "#3c3c3c"
            size: 14
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            visible: !model.elements
        }
    }

    property Component labelDelegate: BasicText {
        id: label

        text: model.text ? model.text : 0
        antialiasing: true
        color: {
            (currentNode === model ) ? "white" : "black"
        }
    }

    property Component isRegionIconDelegate: Item {
        width: rowHeight
        height: rowHeight

        FontAwesomeIcon {
            name: "CheckEmpty"
            color: "#3c3c3c"
            size: 9
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            visible: !!model.isRefinementObject
        }
    }

    contentItem: Loader {
        id: content

        property var elements: model
        property var treeNodeElement: []

        onLoaded: item.isRoot = true
        sourceComponent: treeBranch

        Component {
            id: treeBranch

            Item {
                property bool isRoot: false

                implicitHeight: column.implicitHeight
                implicitWidth: column.implicitWidth

                Column {
                    id: column
                    x: 0

                    Item { height: isRoot ? 0 : rowHeight; width: 1}

                    Repeater {
                        property var treeNodePath: treeNodeElement

                        model: elements

                        Item {
                            id: filler

                            property var _model: model
                            property var _treeNodePath: treeNodeElement.concat([model.text])

                            width: Math.max(loader.width + columnIndent, row.width)
                            height: Math.max(row.height, loader.height)

                            Rectangle {
                                id: borderRec

                                x: root.mapToItem(borderRec, 0, 0).x
                                width: root.contentWidth
                                height: rowHeight
                                color: "transparent"
                                border.width: 1
                                border.color: "transparent"

                                ColorAnimation on color {
                                    id: colorAnim

                                    from: "#fff"; to: "#D0E6F7"
                                    duration: 400
                                    running: false
                                }
                                ColorAnimation on border.color {
                                    id: borderColorAnim

                                    from: "#fff"; to: "#439BDF"
                                    duration: 400
                                    running: false
                                }
                            }

                            Rectangle {
                                id: rowfill

                                x: root.mapToItem(rowfill, 0, 0).x
                                width: root.contentWidth
                                height: rowHeight
                                visible: currentNode === model
                                color: "#4EA6EB"
                                border.width: 1
                                border.color: "#439BDF"
                            }

                            MouseArea {
                                id: mouseAreaForRowFill

                                anchors.fill: rowfill
                                hoverEnabled: true
                                z:3 // so mouseover works
                                propagateComposedEvents: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onPressed: {
                                    root.currentNodePath = parent._treeNodePath
                                    currentNode = model
                                    currentItem = loader
                                    forceActiveFocus()

                                    if (pressedButtons === Qt.RightButton) {
                                        root.menu.treeViewMenu.__xOffset = 5
                                        root.menu.treeViewMenu.__yOffset = 10
                                        root.menu.treeViewMenu.popup()
                                    }
                                }
                                onEntered: {
                                    colorAnim.running = true
                                    borderColorAnim.running = true
                                }
                                onExited: {
                                    borderRec.border.color = "transparent"
                                    colorAnim.running = false
                                    borderRec.color = "transparent"
                                    borderColorAnim.running = false
                                }
                                onDoubleClicked: {
                                    loader.expanded = !loader.expanded
                                    if (!model.elements) {
                                    }
                                }

                                Connections {
                                    target: root
                                    onNewCurrentNode: {
                                        if (nodePath === model.text) {
                                            root.currentNodePath = filler._treeNodePath
                                            currentNode = model
                                            currentItem = loader
                                            forceActiveFocus()
                                        }
                                    }
                                }
                                enabled: !root.isGettingRenamed

                                Loader {
                                    property var model: _model
                                    sourceComponent: rightInfo
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    height: parent.height
                                }
                            }

                            Loader {
                                property var model: _model
                                sourceComponent: isRegionIconDelegate
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: rowfill.right
                            }

                            Row {
                                id: row

                                Item {
                                    width: rowHeight*1.5
                                    height: rowHeight
                                    visible: !!model.elements ? true : false

                                    Item {
                                        id: expander

                                        anchors.fill: parent
                                        width: rowHeight
                                        height: rowHeight

                                        FontAwesomeIcon {
                                            name: "AngleRight"
                                            color: "black"
                                            size: 12
                                            opacity: mouseAreaForExpander.containsMouse ? 0.5 : 1
                                            anchors.centerIn: parent
                                            rotation: loader.expanded ? 90 : 0
                                            Behavior on rotation {NumberAnimation { duration: 50}}
                                        }
                                    }

                                    MouseArea {
                                        id: mouseAreaForExpander

                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: loader.expanded = !loader.expanded
                                    }
                                }
                                Item {
                                    width: rowHeight
                                    height: rowHeight
                                    Item {
                                        width: parent.width
                                        height: parent.height
                                    }
                                    visible: !!model.elements ? false : true
                                }
                                Loader {
                                    property var model: _model
                                    property bool loaderExpanded: loader.expanded
                                    sourceComponent: folderIconDelegate
                                    anchors.verticalCenter: parent.verticalCenter
                                    active: !!model.elements
                                }
                                Loader {
                                    property var model: _model
                                    sourceComponent: fileIconDelegate
                                    anchors.verticalCenter: parent.verticalCenter
                                    active: !model.elements
                                }
                                Loader {
                                    property var model: _model
                                    sourceComponent: labelDelegate
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            Loader {
                                id: loader

                                property var node: model
                                property bool expanded: true
                                property var elements: model.elements
                                property var text: model.text
                                property var treeNodeElement: _treeNodePath


                                x: columnIndent
                                height: expanded ? implicitHeight : 0
                                visible: expanded
                                asynchronous: true
                                sourceComponent: (!!model.elements) ? treeBranch : undefined
                            }
                        }
                    }
                }
            }
        }
    }
}

