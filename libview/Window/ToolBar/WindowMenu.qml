import QtQuick 2.4
import QtQuick.Controls 1.3

Menu {
    title: "DICE"

    MenuItem {
        action: mainWindow.getCoreApp("Home").actions.createNewProjectAction
    }
    MenuItem {
        action: mainWindow.getCoreApp("Home").actions.loadProjectAction
    }
    MenuItem {
        action: mainWindow.getCoreApp("Home").actions.openDiceSettingsAction
    }

    MenuSeparator {}

    MenuItem {
        action: actions.tooggleToolBar
    }
    MenuItem {
        action: actions.tooggleNaviBar
    }

    MenuSeparator {}

    MenuItem {
        action: actions.quitDiceAction
    }
}
