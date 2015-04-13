import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {
    id: root
    objectName: "Connector"

    property var fromRect: !!from ? from : dummyRect
    property var toRect: !!to ? to : dummyRect
    property var from
    property var to
    property var fromDock: !!from ? from.outputDock : dummyRect
    property var toDock: !!to ? to.inputDock : dummyRect

    property int currentMousePositionX: deskData.currentMousePositionX
    property int currentMousePositionY: deskData.currentMousePositionY
    property var currentMousePosition: mapToItem(canvas, currentMousePositionX, currentMousePositionY)
    property var currentPressedButtons: deskData.currentPressedButtons

    property bool hovered: false
    property bool selected: deskData.currentFocusedConnector == root

    property Item dummyRect: Item {}

    signal workSpaceClicked

    width: parent.width
    height: parent.height

    Component.onCompleted: deskData.workSpaceClicked.connect(workSpaceClicked)

    Canvas {
        id: canvas

        property int lineWidth: 4
        property color drawColor: "black"
        property int border: 50
        property var context: getContext('2d')

        x: Math.min(fromRect.x,toRect.x)  - border
        y: Math.min(fromRect.y, toRect.y) - border
        width: toRect.x >= fromRect.x ? Math.abs(toRect.x-fromRect.x)+toRect.width+2*border : Math.abs(toRect.x-fromRect.x)+fromRect.width+2*border
        height: toRect.y >= fromRect.y ? Math.abs(toRect.y-fromRect.y)+toRect.height+2*border : Math.abs(toRect.y-fromRect.y)+fromRect.height+2*border

        antialiasing: true

        onLineWidthChanged: requestPaint()
        onDrawColorChanged: requestPaint()

        opacity: 1
        onOpacityChanged: {
            if (opacity === 0.7)
                drawColor = colors.highlightColor
            else
                drawColor = "black"
        }

        onPaint: {
            var ctx = canvas.context
            ctx.beginPath()
            ctx.strokeStyle = drawColor
            ctx.lineWidth = lineWidth
            var p1={}, p2={}
            p1 = fromDock.mapToItem(canvas, fromDock.width, fromDock.height/2)
            p2 = toDock.mapToItem(canvas, 0, toDock.height/2)

            var offset = border
            ctx.moveTo(p1.x, p1.y);
            ctx.bezierCurveTo(p1.x+offset, p1.y, p2.x-offset, p2.y, p2.x, p2.y)
            ctx.stroke()
            ctx.closePath()
        }
    }

    onFromChanged: {
        if (!from && objectName === "Connector")
            root.destroy()
    }

    onToChanged: {
        if (!to && objectName === "Connector")
            root.destroy()
    }

    onCurrentMousePositionChanged: {
        if (checkIfMouseOverPath(currentMousePosition.x, currentMousePosition.y)) {
            hovered = true
        }
        else {
            hovered = false
        }
    }

    onWorkSpaceClicked: {
        if (checkIfMouseOverPath(currentMousePosition.x, currentMousePosition.y)) {
            deskData.currentFocusedConnector = root
            if (currentPressedButtons === Qt.RightButton)
                rightClickMenu.connectorMenu.popup()
        }
    }

    states: [
        State {
            name: "hovered"
            when: hovered && !selected
            PropertyChanges { target: canvas; drawColor: "yellow"}
        },
        State {
            name: "selected"
            when: selected
            PropertyChanges { target: canvas; drawColor: colors.highlightColor }
        }
    ]

    transitions: Transition {
        ColorAnimation { duration: 50 }
    }

    function checkIfMouseOverPath(mX, mY) {
        var p = canvas.context.getImageData(mX, mY, 1, 1).data
        return p[3] !== 0
    }
}
