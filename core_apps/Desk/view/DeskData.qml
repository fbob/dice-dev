import QtQuick 2.4

QtObject {
    id: root

    property var currentApp: undefined
    property var currentFocusedStreamItem: undefined
    property var currentFocusedConnector: undefined
    property var currentFocusedItem: undefined

    property var connectingFromApp: undefined
    property var connectingToApp: undefined
    property var lastRemovedApp: undefined

    property int currentMousePositionX
    property int currentMousePositionY

    property var currentPressedButtons

    signal workSpaceClicked

    Component.onCompleted: {
        // connect the list of opened stream items to the tabsBar
        tabsBar.openedStreamItems = Qt.binding(function() {return root.openedStreamItems})
        mainWindow.openedStreamItems = Qt.binding(function() {return root.openedStreamItems})
    }

    function closeCurrentApp() {
        // TODO: remove this function? it is not used anywhere
        currentApp = undefined
        mainWindow.closeApp()
    }

    function removeCurrentConnector() {
        var from = deskData.currentFocusedConnector.from.app
        var to = deskData.currentFocusedConnector.to.app
        if (dice.desk.disconnectStreamItems(from, to)) {
            deskData.currentFocusedConnector.destroy()
        }
    }

    property Connections deskConnections: Connections {
        target: dice.desk
        onStreamItemOpened: {
            currentApp = streamItem
            for (var i=0; i<openedStreamItems.count; i++) {
                if (openedStreamItems.get(i).streamItem === streamItem) {
                    openedStreamItems.activeStreamItem = i
                    mainWindow.openApp(streamItem)
                    return
                }
            }
            openedStreamItems.append({"streamItem": streamItem})
            openedStreamItems.activeStreamItem = openedStreamItems.count-1
            mainWindow.openApp(streamItem)
        }
        onStreamItemClosed: {
            if (streamItem === currentApp) {
                openedStreamItems.activeStreamItem = -1
                mainWindow.closeApp()
            }
            for (var i=0; i<openedStreamItems.count; i++) {
                if (openedStreamItems.get(i).streamItem === streamItem)
                    openedStreamItems.remove(i)
            }
        }
    }

    property ListModel openedStreamItems: ListModel {
        property int activeStreamItem: -1
        onActiveStreamItemChanged: {
            if (activeStreamItem !== -1) {
                currentApp = openedStreamItems.get(activeStreamItem).streamItem
                mainWindow.openApp(currentApp)
            } else {
                currentApp = undefined
            }
        }
    }
}
