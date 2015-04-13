import QtQuick 2.4

Item {
    width: 15
    height: parent.height

    // left Line
    Rectangle {
        width: 3
        height: parent.height * 0.9
        color: colors.borderColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - 1

        Rectangle {
            width: 2
            height: parent.height
            anchors.right: parent.right
            color: "#fff"
            radius: parent.radius
        }
    }
}
