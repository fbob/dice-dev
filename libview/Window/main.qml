import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2

import DICE.Theme 1.0
import DICE.Components 1.0
import DICE.Variables 1.0

import "ToolBar"
import "TabsBar"
import "Navi"
import "MainWindow"
import "BottomControls"
import "Overlays"

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"

    title: qsTr("DICE: ")+dice.project.name

    width: maximumWidth
    height: maximumHeight
    minimumHeight: 300
    minimumWidth: 400
    visible: true

    Actions { id: actions }

    // global variables
    property var fonts: CustomFonts { }
    property var colors: CustomColors { }
    property var variables: Variables { }

    property string helpPath: ""

    Component.onCompleted: {
        dice.appWindow = appWindow
        dice.mainWindow = mainWindow
    }


    toolBar: ToolBar { id: topMenuBar }

    // tabs bar used for apps
    TabsBar { id: tabsBar }

    MainNavi { id: mainNavi }

    SplitView {
        id: mainSplitView

        orientation: Qt.Vertical

        width: appWindow.width-mainNavi.width
        height: appWindow.height-tabsBar.height-toolBar.height-bottomControls.height
        anchors.left: mainNavi.right
        anchors.top: tabsBar.bottom

        MainWindow {
            id: mainWindow
            objectName: "mainWindow"
        }

        Console {
            id: consoleWindow

            visible: bottomControls.consoleExpanded
            width: parent.width
            height: visible ? 150 : 0
        }
    }

    BottomControls {
        id: bottomControls

        anchors.left: mainNavi.right
        anchors.top: mainSplitView.bottom
        anchors.right: mainSplitView.right
        button1.newContent: consoleWindow.newText
    }

    // global dialogs and overlays
    ErrorDialog { id: overlayDialog }
    CustomDialog { id: customDialog }

    property var leftOptionsSideBar: los
    LeftOptionsSideBar {id: los}

    property var rightOptionsSideBar: ros
    RightOptionsSideBar {id: ros}

    // global functions
    function goToCoreApp(title){
        mainNavi.gotoCoreApp(title)
    }

    // needs to stay at the bottom
    property Item overlayLayer: overlayLayer
    OverlayLayer { id: overlayLayer }
}
