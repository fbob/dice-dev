import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.Theme 1.0

FocusScope {
    id: root

    property bool newText: false // Indicator that new text is available in the console. Should cause some blinking/coloring/....

    Layout.minimumHeight: visible ? 100 : 0

    onVisibleChanged: {
        if (visible) {
            newText = false
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ConsoleBar {}

        TextArea {
            id: globalConsole
            objectName: "globalConsole"

            property string logBuffer: ""

            focus: true

            Layout.fillHeight: true
            Layout.fillWidth: true
            textFormat: TextEdit.RichText
            readOnly: true

            onVisibleChanged: {
                if (visible) {
                    append(logBuffer)
                    logBuffer = ""
                }
            }

            function newLog(log) {
                if (visible) {
                    append(log)
                } else {
                    logBuffer += log
                    root.newText = true
                }
            }

            Connections {
                target: dice
                onNewLog: {
                    globalConsole.newLog(log)
                }
            }

            style: TextAreaStyle {
                font.family: fonts.codeTextFont
                renderType: Text.QtRendering
                font.pointSize: 9
            }
        }
    }

    Action {
        id: escapeKey
        enabled: bottomControls.focus || root.focus
        text: "Quick Search"
        shortcut: "ESC"
        onTriggered: bottomControls.consoleExpanded ? bottomControls.expandConsole() : undefined
        tooltip: "Quick Search"
    }
}
