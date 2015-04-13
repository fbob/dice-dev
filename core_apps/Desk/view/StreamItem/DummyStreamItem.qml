import QtQuick 2.4

StreamItem {
    id: root
    objectName: "dummyStreamItem"

    visible: false
    Drag.active: false
    zDepth: 5

    app: Item {
        property string name: ""
        property string instanceName: name
        property string status: "idle"
        property string packageName: ""
    }

    property bool isInWorkSpace: false

    onXChanged: isInWorkSpace = calculateIsInWorkSpace()
    onYChanged: isInWorkSpace = calculateIsInWorkSpace()

    function setPos(xPos, yPos) {
        x = xPos
        y = yPos
    }

    function makeDraggable() {
        Drag.active = true
    }

    function setItemName(instanceName, packageName) {
        app.name = instanceName
        app.packageName = packageName
    }

    function calculateIsInWorkSpace() {
        // use the workSpaceView as reference, as workSpace is a bigger rectangle
        var d = root.mapToItem(desk.workSpaceView, 0, 0)
        return d.x > 0 && d.x < desk.workSpaceView.width && d.y > 0 && d.y < desk.workSpaceView.height
    }

    function release() {
        visible = false
        Drag.active = false
        if (isInWorkSpace) {
            dropOnWorkSpace()
        }
    }

    function dropOnWorkSpace() {
        // map to workSpace (x must be subtracted by appView.width as this is the reference point the dummyStreamItem is positioned at)
        var wsCoords = desk.workSpaceView.mapToItem(desk.workSpace, x-desk.appsView.width, y)
        dice.desk.createStreamItem(app.packageName, wsCoords.x, wsCoords.y)
    }
}
