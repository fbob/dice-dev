import QtQuick 2.4

import "../StreamItem"

Item {
    id: root

    property bool ctrlPressed: false
    property bool connectingStreamItems: false
    property var prevConnectingItem: undefined
    property bool disableOtherMouseAreas: connectingStreamItems && prevConnectingItem !== undefined
    property alias workSpaceMouseArea: workSpaceMouseArea

    DummyConnector {
        id: dummyConnector

        visible: root.prevConnectingItem !== undefined
        from: root.prevConnectingItem
        to: dummyRect

        Item {
            id: dummyRect
            property alias inputDock: _inputDock

            width: 1
            height: 1

            x: workSpaceMouseArea.mouseX
            y: workSpaceMouseArea.mouseY

            Item {
                id: _inputDock

                width: 1
                height: 1
            }
        }
    }

    transformOrigin: Item.TopLeft

    //    onScaleChanged: {
    //        if (root.scale > 1.5) {
    //            backgroundGrid.pixelDistance = 25
    //        }
    //        else
    //        {
    //            if (root.scale < 0.8) {
    //                backgroundGrid.pixelDistance = 75
    //            }
    //            else {
    //                backgroundGrid.pixelDistance = 50
    //            }
    //        }
    //        update()
    //    }

    function createStreamItem(app) {
        var newComponent = Qt.createComponent("../StreamItem/StreamItem.qml");
        if (newComponent.status === Component.Ready) {
            var newID = "sc_"+app.id;
            var newItem = newComponent.createObject(root, {id: newID, app: app});
//            app.initialize();
        } else {
        }
    }

    function createConnector(appFrom, appTo) {
        var newComponent = Qt.createComponent("../StreamItem/Connector.qml");
        if (newComponent.status === Component.Ready) {
            var newConnector = newComponent.createObject(root, {from: appFrom.deskItem, to: appTo.deskItem});
        } else {
        }
    }

    function startCreatingConnection(startItem) {
        if (startItem !== undefined) {
            root.prevConnectingItem = deskData.currentFocusedStreamItem
        }
        root.connectingStreamItems = true
    }

    function cancelCreatingConnection() {
        root.prevConnectingItem = undefined
        root.connectingStreamItems = false
    }

    property Connections connectorConnections: Connections {
        target: deskData
        onCurrentFocusedStreamItemChanged: {
            if (root.connectingStreamItems && deskData.currentFocusedStreamItem) {
                if (root.prevConnectingItem === undefined) {
                    root.prevConnectingItem = deskData.currentFocusedStreamItem
                } else {
                    var fromApp = root.prevConnectingItem.app
                    var toApp = deskData.currentFocusedStreamItem.app
                    dice.desk.connectStreamItems(fromApp, toApp)
                    root.prevConnectingItem = undefined
                    root.connectingStreamItems = false
                }
            }
        }
    }

    function getInitMouseCoordinates(pressedButtons, x, y) {
        var init = {}
        if (pressedButtons === Qt.MiddleButton) {
            init = {
                "initX": x,
                "initY": y
            }
        }
        else
        {
            init = {
                "initX": 0,
                "initY": 0
            }
        }
        return init
    }

    function zoom(scaleFactor, angle) {
        var maxZoom = 2.5
        var minZoom = 0.5
        if (zoom.initWidth === undefined) {
            zoom.initWidth = root.width
        }
        if (zoom.initHeight === undefined) {
            zoom.initHeight = root.height
        }
        if (angle > 0) {
            if (scaleFactor + 0.1 < maxZoom )
                scaleFactor += 0.1
        }
        if (angle < 0) {
            if (scaleFactor - 0.1 > minZoom )
                scaleFactor -= 0.1
        }
        root.scale = scaleFactor
        workSpaceScrollView.flickableItem.contentWidth = zoom.initWidth*scaleFactor
        workSpaceScrollView.flickableItem.contentHeight = zoom.initHeight*scaleFactor
    }

    // Search for a child item with an objectName in the workSpace
    function searchForItemOnWorkSpace(item, objectName) {
        for (var i in workSpace.children) {
            var child = workSpace.children[i]
            if ( (child.objectName === objectName)
                    && (child === item) ) {
                return child
            }
        }
    }

    // Find selected streamItem in the workSpace and delete it
    function deleteStreamItem(selectedItem) {
        var child = searchForItemOnWorkSpace(selectedItem, "StreamItem")
        child.destroy()
    }

    // Check if mouse over a connector item
    function checkIfMouseOverConnector(mouse) {
        var tolerance = 0
        for (var i in workSpace.children) {
            var child = workSpace.children[i]
            if (child.objectName === "Connector") {
                var mouseXY = mapToItem(child.canvas, mouse.x, mouse.y)
                var mX = mouseXY.x
                var mY = mouseXY.y
                child.pathHovered = false
                for (var k=mX-tolerance; k <= mX + tolerance; k++) {
                    for (var j=mY-tolerance; j <= mY + tolerance; j++) {
                        if (child.canvas.context.isPointInPath(k, j)) {
                            child.pathHovered = true
                            return true
                        }
                    }
                }
            }
        }
    }

    // Edit InstanceName of a StreamItem on the WorkSpace
    function editStreamItem(streamItem) {
        if (streamItem === undefined)
            return false
        streamItem.isGettingRenamed = true
    }

    MouseArea {
        id: workSpaceMouseArea

        property int initX
        property int initY
        property int deltaX
        property int deltaY
        property real scrollSpeed: 10

        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true

        //        onWheel: {
        //            if (ctrlPressed) {
        //                var angle = wheel.angleDelta.y
        //                zoom(root.scale, angle)
        //            }
        //            else
        //                wheel.accepted = false
        //        }
        onWheel: {
            var angle = wheel.angleDelta.y
            zoom(root.scale, angle)
        }

        onPressed: {
            initX = mouse.x
            initY = mouse.y
            root.forceActiveFocus()
            deskData.currentFocusedStreamItem = undefined
            deskData.currentFocusedConnector = undefined

            if (pressedButtons === Qt.RightButton && root.connectingStreamItems) {
                root.cancelCreatingConnection()
            }
            deskData.currentPressedButtons = pressedButtons
            deskData.workSpaceClicked()

            if (pressedButtons === Qt.MiddleButton)
                cursorShape = Qt.SizeAllCursor
        }

        onMouseXChanged: {
            if (pressedButtons === Qt.MiddleButton) {
                deltaX = (mouse.x - initX)*scale
                if (  (workSpaceScrollView.flickableItem.atXBeginning && (deltaX > 0) )
                        | (workSpaceScrollView.flickableItem.atXEnd && (deltaX < 0) ) )
                        deltaX = 0
                else
                    workSpaceScrollView.flickableItem.contentX -= deltaX
            }
            deskData.currentMousePositionX = workSpaceMouseArea.mouseX
        }

        onMouseYChanged: {
            if (pressedButtons === Qt.MiddleButton) {
                deltaY = (mouse.y - initY)*scale
                if (  (workSpaceScrollView.flickableItem.atYBeginning && (deltaY > 0) )
                        | (workSpaceScrollView.flickableItem.atYEnd && (deltaY < 0) ) )
                    deltaY = 0
                else
                    workSpaceScrollView.flickableItem.contentY -= deltaY
            }
            deskData.currentMousePositionY = workSpaceMouseArea.mouseY
        }

        onReleased: {
            cursorShape = Qt.ArrowCursor
            initX = mouse.x
            initY = mouse.y
        }

        onEntered: {
            if (deskData.currentFocusedStreamItem | deskData.currentFocusedConnector) {
                mouse.accepted = false
                deskData.currentFocusedItem = root
            }
        }
    }

    Keys.onEscapePressed: {
        if (root.connectingStreamItems) cancelCreatingConnection()
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Control:
            ctrlPressed = true
            break
        }
    }

    Keys.onReleased: {
        switch (event.key) {
        case Qt.Key_Control:
            ctrlPressed = false
            break
        }
    }
}
