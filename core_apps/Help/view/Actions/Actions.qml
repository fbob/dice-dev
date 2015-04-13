import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.3

Item {
    id: root

    property var goHomeAction: Action {
        id: goHomeAction
        text: "Home"
        shortcut: "Ctrl+K"
        onTriggered: {
            webEngineView.load(homeHTMLPath)
        }
        enabled: webEngineView.focus
        tooltip: text
        iconSource: "images/home.svg"
        iconName: text
    }
    property var goBackAction: Action {
        id: goBackAction
        text: "Back"
        shortcut: "Ctrl+B"
        onTriggered: {
            webEngineView.goBack()
        }
        enabled: webEngineView.focus && webEngineView.canGoBack
        tooltip: text
        iconSource: "images/leftanglearrow.svg"
        iconName: text
    }
    property var goForwardAction: Action {
        id: goForwardAction
        text: "Forward"
        shortcut: "Ctrl+F"
        onTriggered: {
            webEngineView.goForward()
        }
        enabled: webEngineView.focus && webEngineView.canGoForward
        tooltip: text
        iconSource: "images/rightanglearrow.svg"
        iconName: text
    }
    property var reloadAction: Action {
        id: reloadAction
        text: "Reload"
        shortcut: "Ctrl+R"
        onTriggered: {
            webEngineView.reload()
        }
        enabled: webEngineView.focus
        tooltip: text
        iconSource: "images/reload.svg"
        iconName: text
    }
}
