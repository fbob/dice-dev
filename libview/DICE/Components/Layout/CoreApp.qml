import QtQuick 2.4

Rectangle {
    property string title
    property Component toolBar
    property Item actions

    property var coreApp: _coreApp

    anchors.fill: parent
//    color: colors.mainBackgroundColor

    function open() {
        mainNavi.gotoCoreApp(title)
    }

    property Component background
    Loader {
        sourceComponent: background
        anchors.fill: parent
    }

    property Component header
    Loader {
        sourceComponent: header
        width: parent.width
        height: item.height
        z: 999
    }

    Component.onCompleted: {
        coreApp.completed()
    }
}
