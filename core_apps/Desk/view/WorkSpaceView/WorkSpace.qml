import QtQuick 2.4

WorkSpaceFunctions {
    id: root

    Component.onCompleted: {
        width = dice.desk.contentWidth
        height = dice.desk.contentHeight
    }

    Grid {
        id: backgroundGrid

        property int pixelDistance: 50
        property int gridPointWidth: 2
        property int gridPointHeight: 2

        rows: Math.round(parent.height/pixelDistance)
        columns: Math.round(parent.width/pixelDistance)

        Repeater {
            model: parent.rows*parent.columns
            Item {
                width: backgroundGrid.pixelDistance
                height: backgroundGrid.pixelDistance

                Rectangle {
                    id: gridPoint
                    width: backgroundGrid.gridPointWidth
                    height: backgroundGrid.gridPointHeight
                    radius: width/2
                    color: "#333"
                    anchors.centerIn: parent
                }
            }
        }
    }
}
