import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Private 1.0

import DICE.Components 1.0

ToolBarMenu {
    id: root

    property var themeSelect: themeSelect
    property bool ideLoaded: false

    ToolBarGroup {
        title: "Controls"

        BigToolBarButton {
            action: actions.undoAction
        }
        BigToolBarButton {
            action: actions.redoAction
        }
        BigToolBarButton {
            action: actions.saveFileAction
        }
    }
    ToolBarGroup {
        title: "Theme"

        ComboBox {
            id: themeSelect

            width: 100
            model: coreApp.editorThemesModel
            style: ComboBoxStyle {
                background: Item {
                    implicitWidth: Math.round(TextSingleton.implicitHeight * 4.5)
                    implicitHeight: Math.max(28, Math.round(TextSingleton.implicitHeight * 1.2))
                    Rectangle {
                        anchors.fill: parent
                        anchors.bottomMargin: control.pressed ? 0 : -1
                        color: "#10000000"
                        radius: baserect.radius
                    }
                    Rectangle {
                        id: baserect
                        color: "#fff"
                        radius: TextSingleton.implicitHeight * 0.16
                        anchors.fill: parent
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: control.hovered || control.activeFocus ? "#47b" : "#666"
                            opacity: control.hovered || control.activeFocus ? 0.01 : 0
                            Behavior on opacity {NumberAnimation{ duration: 100 }}
                        }
                        Rectangle {
                            height: 2
                            width: parent.width
                            anchors.bottom: parent.bottom
                            color: control.hovered || control.activeFocus ? colors.highlightColor : colors.borderColor

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }
                }
            }
            onCurrentTextChanged: {
                if (ideLoaded) {
                    var theme = currentText
                    webEngineView.runJavaScript("editor.setOption('theme','"+ theme +"')")
                    coreApp.editorTheme = currentText
                }
            }
            Component.onCompleted: {
                currentIndex = coreApp.getEditorThemeIndex()
                var theme = currentText
                webEngineView.runJavaScript("editor.setOption('theme','"+ theme +"')")
                root.ideLoaded = true
            }
        }
    }
}
