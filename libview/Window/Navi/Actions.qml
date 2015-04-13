import QtQuick 2.4
import QtQuick.Controls 1.3


Item {
    Action {
        id: nextNaviButton
        text: "Next Navi-Button or Tab"
        shortcut: "Ctrl+Tab"
        onTriggered: {
            var openTabsNumber = tabsBar.openedStreamItems.count
            var currentTabIndex = tabsBar.openedStreamItems.activeStreamItem

            if (!!mainWindow.getCoreApp("Desk").deskData.currentApp) {
                if (openTabsNumber > 1 && currentTabIndex < openTabsNumber - 1)
                    tabsBar.openedStreamItems.activeStreamItem += 1
                else
                    tabsBar.openedStreamItems.activeStreamItem = 0
            }
            else
                mainNavi.incrementCurrentIndex()
        }
        tooltip: "Go to Next Navi-Button"
    }
    Action {
        id: prevNaviButton
        text: "Previous Navi-Button or Tab"
        shortcut: "Ctrl+Shift+Tab"
        onTriggered: {
            var openTabsNumber = tabsBar.openedStreamItems.count
            var currentTabIndex = tabsBar.openedStreamItems.activeStreamItem

            if (!!mainWindow.getCoreApp("Desk").deskData.currentApp) {
                if (openTabsNumber > 1 && currentTabIndex > 0 )
                    tabsBar.openedStreamItems.activeStreamItem -= 1
                else
                    tabsBar.openedStreamItems.activeStreamItem = openTabsNumber - 1
            }
            else
                mainNavi.decrementCurrentIndex()
        }
        tooltip: "Go to Previous Navi-Button"
    }
    Action {
        id: closeOptionsSideBar
        shortcut: "ESC"
        onTriggered: {
            if (leftOptionsSideBar.visible)
                leftOptionsSideBar.close()
            if (rightOptionsSideBar.visible)
                rightOptionsSideBar.close()
        }
        enabled: rightOptionsSideBar.visible || leftOptionsSideBar.visible
    }
    Action {
        id: closeTab
        text: "Close Tab"
        shortcut: "Ctrl+W"
        enabled: !!mainWindow.getCoreApp("Desk").deskData.currentApp
        onTriggered: {
            var openTabsNumber = tabsBar.openedStreamItems.count
            var currentTabIndex = tabsBar.openedStreamItems.activeStreamItem

            dice.desk.closeStreamItem(mainWindow.getCoreApp("Desk").deskData.currentApp)

            if (openTabsNumber > 0 && currentTabIndex === openTabsNumber - 1)
                tabsBar.openedStreamItems.activeStreamItem = currentTabIndex - 1
            else
                if (openTabsNumber > 0)
                    tabsBar.openedStreamItems.activeStreamItem = currentTabIndex
        }
    }
    property var openHelp: Action {
        id: openHelp

        text: "Open Help"
        shortcut: "F1"
        onTriggered: {
            mainWindow.getCoreApp("Help").openHelp()
        }
    }
    property var openFileInEditor: Action {
        id: openFileInEditor

        text: "Open File in Editor"
        shortcut: "F3"
        onTriggered: {
            mainWindow.getCoreApp("IDE").openIDE()
        }
    }
    property var tooggleToolBar: Action {
        id: toggleToolBar

        text: "Toggle ToolBar"
        shortcut: "Ctrl+M"
        onTriggered: {
            toolBar.toggleWindowBar()
        }
    }
    property var tooggleNaviBar: Action {
        id: tooggleNaviBar

        text: "Toggle NaviBar"
        shortcut: "Ctrl+B"
        onTriggered: {
            mainNavi.toggleWidthNavi()
        }
    }
    property var quitDiceAction: Action {
        id: quitDiceAction

        text: "Quit DICE"
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }
}
