import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import DICE.Theme 1.0
import DICE.Variables 1.0
import DICE.Components 1.0

Rectangle {
    id: appRoot

    property var app
    property var mainWindow
    property var appWindow
    property var leftOptionsSideBar: appWindow.leftOptionsSideBar
    property var rightOptionsSideBar: appWindow.rightOptionsSideBar
    property var modalWindow: appWindow.modalWindow

    property Component toolBar
    property Component navi
    property Component vis
    property Component naviHeader
    property Component mainHeader
    property Menu mainHeaderMenu
    property Component visHeader

    property var actions

    property var fonts: appWindow.fonts
    property var colors: appWindow.colors
    property var variables: appWindow.variables
    property string helpUrl: appWindow.helpUrl
    property string helpUrlFragment: appWindow.helpUrlFragment

    // TODO: rename *Object to *Item
    property var naviObject
    property var mainObject
    property var visItem
    property var visHeaderItem
    property var defaultAppLoader: DefaultAppLoader { view: appRoot }

    property string title: app.name

    property var contentItems: ({})
    property var contentIndexList: ({})

    function openTab(name) {
        appRoot.naviObject.currentIndex = contentIndexList[name]
    }

    anchors.fill: parent
    color: colors.mainBackgroundColor

    Component.onCompleted: console.log("app: "+app)

    FileDialog {
        id: fileDialog
        selectMultiple: false
        property var acceptedCallback
        property var rejectedCallback

        onAccepted: {
            if (!!acceptedCallback) {
                if (selectMultiple) {
                    // we need to convert the list<url> to a JS array
                    var urls = []
                    for (var i=0; i<fileDialog.fileUrls.length; i++)
                        urls.push(fileDialog.fileUrls[i])
                    app.call(acceptedCallback, [urls])
                } else {
                    app.call(acceptedCallback, [fileDialog.fileUrl])
                }
                acceptedCallback = undefined
            }
        }

        onRejected: {
            if (rejectedCallback) {
                app.call(rejectedCallback)
                rejectedCallback = undefined
            }
        }

        function open(callback, title, nFilters, multiple, rejectedCallback) {
            if (!nFilters) nFilters = []
            if (multiple === undefined) multiple = false

            if (!!title) fileDialog.title = title
            fileDialog.nameFilters = nFilters
            fileDialog.selectMultiple = multiple
            acceptedCallback = callback
            fileDialog.rejectedCallback = rejectedCallback
            fileDialog.visible = true // instead of open
        }
    }

    Rectangle {
        id: appMainWindow

        anchors.fill: parent
        color: "transparent"

        SplitView {
            anchors.fill: parent
            orientation: Qt.Horizontal

            Item {
                width: 200
                Layout.minimumWidth: 200
                Layout.fillHeight: true

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: variables.windowPadding
                    border.color: colors.borderColor
                    border.width: 1
                    color: "transparent"

                    Rectangle {
                        id: naviBackground

                        anchors.fill: parent
                        color: "#eee"
                        opacity: 0.2
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#C0C0C0"; }
                            GradientStop { position: 0.9; color: "#767676"; }
                            GradientStop { position: 1.0; color: "#C0C0C0"; }
                        }
                    }

                    ColumnLayout {
                        spacing: 0
                        height: parent.height
                        width: parent.width

                        Loader {
                            id: naviHeaderLoader

                            height: appRoot.naviHeader.height
                            Layout.preferredHeight: height
                            Layout.fillWidth: true
                            sourceComponent: appRoot.naviHeader
                        }

                        Item {
                            height: 20
                            width:1
                        }

                        Loader {
                            id: naviLoader

                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            sourceComponent: ScrollView_DICE {
                                id: scrollView

                                Loader {
                                    width: scrollView.contentWidth
                                    sourceComponent: appRoot.navi
                                    onLoaded: appRoot.naviObject = item
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.minimumWidth: 410
                Layout.maximumWidth: 600
                Layout.fillHeight: true

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: variables.windowPadding
                    border.color: colors.borderColor
                    border.width: 1
                    color: "transparent"

                    Rectangle {
                        id: mainBackground
                        anchors.fill: parent
                        color: "#eee"
                        opacity: 0.02
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#C0C0C0"; }
                            GradientStop { position: 1.0; color: "#767676"; }
                        }
                    }

                    ColumnLayout {
                        spacing: 0
                        height: parent.height
                        // anchroring to the sides to leave the border visible
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 1
                        anchors.rightMargin: 1

                        Loader {
                            id: mainHeaderLoader

                            height: appRoot.mainHeader.height
                            Layout.preferredHeight: height
                            Layout.fillWidth: true
                            sourceComponent: appRoot.mainHeader
                            onItemChanged: {
                                item.text = Qt.binding(function() {
                                    return appRoot.naviObject.model.get(appRoot.naviObject.currentIndex).listItem
                                })
                                item.menu = Qt.binding(function() {
                                    return appRoot.mainHeaderMenu
                                })

                            }
                        }

                        Item {
                            height: 10
                            width: 1
                        }

                        Loader {
                            id: mainLoader

                            Layout.fillHeight: true
                            Layout.fillWidth: true
//                            asynchronous: true // Causes crash because of threading problems: https://bugreports.qt-project.org/browse/QTBUG-35989

                            sourceComponent: PaddedScrollViewRect {
                                id: scrollViewMain

                                contentHeight: rect.height + 5

                                Item {
                                    width: scrollViewMain.contentWidth
                                    height: repeater.height + 25 // +25 to add padding to bottom

                                    Item {
                                        id: rect

                                        anchors.fill: parent
                                        anchors.margins: 1

                                        Repeater {
                                            id: repeater

                                            property var currentItem

                                            height: (!!currentItem)? currentItem.height:0
                                            model: appRoot.naviObject.model

                                            Loader {
                                                property bool activeTab: index === appRoot.naviObject.currentIndex
                                                property bool wasActive
                                                property int appHeight: scrollViewMain.height

                                                width: rect.width
                                                onActiveTabChanged: {
                                                    activeTab ? wasActive = true : wasActive = false
                                                    if (activeTab && item) repeater.currentItem = item
                                                }
                                                visible: activeTab
                                                source: pageLocation
                                                onLoaded: {
                                                    if (index === 0) repeater.currentItem = item

                                                    appRoot.contentItems[listItem] = item
                                                    appRoot.contentIndexList[listItem] = index
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.minimumWidth: 100
                Layout.fillHeight: true

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: variables.windowPadding
                    border.color: colors.borderColor
                    border.width: 1
                    color: "transparent"

                    Rectangle {
                        id: visBackground

                        anchors.fill: parent
                        color: "#eee"
                        opacity: 0.2
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#C0C0C0"; }
                            GradientStop { position: 0.9; color: "#767676"; }
                            GradientStop { position: 1.0; color: "#C0C0C0"; }
                        }
                    }

                    ColumnLayout {
                        spacing: 0
                        anchors.fill: parent
                        anchors.leftMargin: 1
                        anchors.rightMargin: 1

                        Loader {
                            id: visHeaderLoader

                            height: appRoot.visHeader.height
                            Layout.preferredHeight: height
                            Layout.fillWidth: true
                            sourceComponent: appRoot.visHeader
                        }

                        Loader {
                            id: visLoader

                            asynchronous: true
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            sourceComponent: vis
                            onLoaded: appRoot.visItem = item
                        }
                    }
                }
            }
        }
    }
}
 
