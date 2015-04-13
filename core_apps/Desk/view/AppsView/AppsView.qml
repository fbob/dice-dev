import QtQuick 2.4
import QtQuick.Layouts 1.1

import DICE.Components 1.0

Rectangle {
    id: root

    property alias appsTreeView: appsTreeView

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
                text: "Apps"
                Layout.fillWidth: true
            }

            Item {
                width: 1
                height: 20
            }

            AppsTree {
                id: appsTreeView

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
