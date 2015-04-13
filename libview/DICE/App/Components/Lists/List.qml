import QtQuick 2.4

import DICE.Components 1.0

ScrollView_DICE {
    id: root

    property ListModel model: ListModel {}
    property var modelData
    property Component delegate

    readonly property int contentHeight: contentItem.height
    property int maxHeight: 150

    onModelDataChanged: {
        model.clear()
        model.append(modelData)
    }

    height: Math.min(maxHeight, contentHeight)
    implicitWidth: 200
    implicitHeight: 160

    contentItem: Loader {
        id: content

        sourceComponent: listViewComponent

        Component {
            id: listViewComponent

            ListView {
                id: listView

                model: root.model
                width: root.width - 10
                height: childrenRect.height

                delegate: root.delegate
            }
        }
    }
}

