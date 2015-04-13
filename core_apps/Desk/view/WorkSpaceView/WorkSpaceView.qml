import QtQuick 2.4
import QtQuick.Layouts 1.1

Rectangle {
    id: root
    color: colors.mainBackgroundColor

    property alias workSpaceHeader: workSpaceHeader
    property alias workSpaceWindow: workSpaceWindow
    property alias workSpace: workSpaceWindow.workSpace

    Rectangle {
        anchors.fill: parent
        anchors.margins: 5
        color: "#fff"
        border.color: colors.borderColor

        ColumnLayout {
            spacing: 0
            width: parent.width
            height: parent.height


            WorkSpaceHeader {
                id: workSpaceHeader
                Layout.fillWidth: true
                height: 50
            }

            WorkSpaceWindow {
                id: workSpaceWindow
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
