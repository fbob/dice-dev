import QtQuick 2.4

import DICE.Components 1.0
import DICE.Theme 1.0

ScrollView_DICE {
    id: root

    property ListModel model: ListModel {}
    property var currentNodePath
    property int rowHeight: 20
    property int columnIndent: 28
    property var currentNode
    property var currentItem
    readonly property int contentHeight: contentItem.height
    property int maxHeight: 150

    implicitWidth: 200
    implicitHeight: 160

    width: parent.width
    height: parent.height

    property Connections deskConn: Connections {
        target: dice.desk
        onAppListChanged: {
            model.clear()
            model.append(dice.desk.appList)
        }
    }

    Component.onCompleted: {
        if (dice.desk) {
            model.clear()
            model.append(dice.desk.appList)
        }
    }

    property Component folderIconDelegate: Item {
        width: icon.size + 10
        height:rowHeight

        FontAwesomeIcon {
            id: icon

            name: loaderExpanded ? "FolderOpen" : "FolderClose"
            color: "#333"
            size: 12
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            visible: !!model.elements
        }
    }

    property Component fileIconDelegate: Item {
        width: 22
        height: rowHeight

        Item {
            height: parent.height
            width:  12*2
            visible: !model.elements
            anchors.verticalCenter: parent.verticalCenter

            Item {
                property string txt : model.text

                width: rowHeight - 10
                height: rowHeight - 10
                anchors.centerIn: parent

                FontAwesomeIcon {
                    name: "File"
                    color: "#3c3c3c"
                    size: 14
                    anchors.centerIn: parent
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !model.elements
                }
            }
        }
    }

    property Component labelDelegate: BasicText {
        id: label

        text: model.text ? model.text : 0
        color: {
            (currentNode === model ) ? "white" : "black"
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
                                onPressed: {
                                    currentNode = model
                                    currentItem = loader
                                    forceActiveFocus()
                                    root.currentNodePath = parent._treeNodePath
                                }
                                onMouseXChanged: {
                                    if (pressed && !model.elements){
                                        var deskDummyStreamItem = desk.dummyStreamItem
                                        drag.target = deskDummyStreamItem
                                        var posX = rowfill.mapToItem(desk, 0, 0).x + mouseX - 2
                                        var posY = rowfill.mapToItem(desk, 0, 0).y + mouseY - 2
                                        deskDummyStreamItem.setPos(posX, posY)
                                        deskDummyStreamItem.visible = true
                                        deskDummyStreamItem.makeDraggable()
                                        deskDummyStreamItem.setItemName(model.name, model.package)
                                    }
                                }
                                onReleased: {
                                    if (!model.elements){
                                        var deskDummyStreamItem = desk.dummyStreamItem
                                        deskDummyStreamItem.release()
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
                            }

                            Row {
                                id: row

                                Item {
                                    width: rowHeight*1.5
                                    height: rowHeight
                                    visible: !!model.elements

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

