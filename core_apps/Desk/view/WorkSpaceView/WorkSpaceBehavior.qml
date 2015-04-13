import QtQuick 2.4

QtObject {
    id: root

    property var workSpaceScrollView: desk.workSpaceView.workSpaceWindow.workSpaceScrollView
    property bool scrollViewInitialized: false

    property Connections scrollFlickableConnections: Connections {
        target: workSpaceScrollView.flickableItem
        onContentXChanged: {
            if (scrollViewInitialized)
                dice.desk.scrollPosX = workSpaceScrollView.flickableItem.contentX
        }
        onContentYChanged: {
            if (scrollViewInitialized)
                dice.desk.scrollPosY = workSpaceScrollView.flickableItem.contentY
        }
        onContentWidthChanged: {
            if (scrollViewInitialized) {
                dice.desk.contentWidth = workSpaceScrollView.flickableItem.contentWidth
            }
        }
        onContentHeightChanged: {
            if (scrollViewInitialized)
                dice.desk.contentHeight = workSpaceScrollView.flickableItem.contentHeight
        }
    }

    property Connections workSpaceConnections: Connections {
        target: desk.workSpace
        onScaleChanged: {
            dice.desk.zoom = desk.workSpace.scale
        }
    }

    property Connections deskConnections: Connections {
        target: dice.desk
        onWorkSpaceLoaded: {
            workSpaceScrollView.flickableItem.contentX = dice.desk.scrollPosX
            workSpaceScrollView.flickableItem.contentY = dice.desk.scrollPosY
            desk.workSpace.scale = dice.desk.zoom
            workSpaceScrollView.flickableItem.contentWidth = dice.desk.contentWidth
            workSpaceScrollView.flickableItem.contentHeight = dice.desk.contentHeight
            root.scrollViewInitialized = true
        }
        onStreamItemCreated: {
            desk.workSpace.createStreamItem(streamItem)
        }
        onConnectionCreated: {
            desk.workSpace.createConnector(from, to)
        }
    }
}
