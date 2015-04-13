import QtQuick 2.4

Rectangle {
    property alias source: image.source

    width: parent.width
    height: 100
    color: "transparent"
    border.color: colors.borderColor

    Image {
        id: image

        height: parent.height-2
        sourceSize.height: parent.height-2
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }
}
