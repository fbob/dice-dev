import QtQuick 2.4
import QtQuick.Controls 1.3

Item {
    property Action runApp: Action {
        text: "Run"
        shortcut: "Ctrl+R"
        tooltip: text
        iconSource: ""
        iconName: "Run " + app.name
        onTriggered: {
            dice.project.scheduleRun(app)
        }
    }
}
