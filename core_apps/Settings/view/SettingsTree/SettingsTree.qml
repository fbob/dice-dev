import QtQuick 2.4
import QtQuick.Layouts 1.1

import DICE.App 1.0

Rectangle {
    id: root

    color: colors.mainBackgroundColor

    Rectangle {
        anchors.fill: parent
        anchors.margins: 5
        color: "#fff"
        border.color: colors.borderColor

        ColumnLayout {
            spacing: 0
            anchors.fill: parent

            MainHeader {
                text: "Applications"
                Layout.fillWidth: true
            }

            Item {
                width: 1
                height: 20
            }

            TreeView {
                modelData: coreApp.settingsTree
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
