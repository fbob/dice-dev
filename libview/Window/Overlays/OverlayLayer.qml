import QtQuick 2.4


Item {
    id: root

    objectName: "overlayLayer"
    property bool overlayOpen: false

    signal open
    signal close

    anchors.fill: parent

    visible: false

    onOpen: {
        if (!visible) {
            visible = true
            focus = true
        }
    }

    onClose: {
        if (visible)
            visible = false
    }

    // Item to change focus from menu
    Item {
        anchors.fill: parent

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            onClicked: {
                root.overlayOpen = false
            }
            propagateComposedEvents: true
        }
    }
}
