import QtQuick 2.4
import QtQuick.Layouts 1.1

Item {
    id: root

    property var current_app: undefined
    property var active_window: repeater.currentItem
    property var home
    property ListModel openedStreamItems

    Layout.fillHeight: true

    // loads the core apps views
    Repeater {
        id: repeater

        property var currentItem

        anchors.fill: parent
        model: dice.coreApps

        Loader {
            id: loader

            property bool activeTab: index === mainNavi.currentIndex
            property bool wasActive
            property var _coreApp: coreApp

            anchors.fill: parent
            onActiveTabChanged: {
                activeTab ? wasActive = true : wasActive = false
                if (activeTab && item) repeater.currentItem = item
            }
            visible: activeTab
            source: pageLocation
            onLoaded: {
                if (index === 0) {
                    repeater.currentItem = item
                    root.home = item
                }
                coreApp.setView(item)
            }
//            asynchronous: true
        }
    }

    // returns the item that is currently displayed (Home, Desk, any app)
    property var currentView: {
        if (!!active_window && active_window.visible) {
            return active_window
        }
        else if (!!current_app) {
            return current_app.getView()
        }
    }

    function openApp(app) {
        if (current_app && current_app !== app) {
            current_app.hide()
        }

        active_window.visible = false
        current_app = app
        app.show()
    }

    function closeApp() {
        if (current_app) {
            current_app.close()
            current_app = undefined
            active_window.visible = true
            openedStreamItems.activeStreamItem = -1
        }
    }

    function hideApp() {
        if (current_app) {
            current_app.hide()
            current_app = undefined
            active_window.visible = true
            openedStreamItems.activeStreamItem = -1
        }
    }

    function getCoreApp(title) {
        for (var i=0; i<dice.coreApps.count; i++) {
            var coreApp = dice.coreApps.get(i)
            if (coreApp.name === title) {
                return repeater.itemAt(i).item
            }
        }
    }
}
