import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import DICE.Components 1.0

import "Actions"
import "Menus"
import "SettingsTree"
import "SettingsView"

CoreApp {
    id: settings

    title: "Settings"
    toolBar: ToolBar {}

    Actions { id: actions }
    actions: actions

    SplitView {
        anchors.fill: parent

        SettingsTree {
            id: settingsTree

            Layout.minimumWidth: 150
            width: 300
        }

        SettingsView {
            id: settingsView

            Layout.fillWidth: true
            Layout.minimumWidth: 300
        }
    }
}
