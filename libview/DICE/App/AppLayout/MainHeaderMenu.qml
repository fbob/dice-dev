import QtQuick.Controls 1.3

Menu {
    MenuItem {
        text: "open config folder"
        onTriggered: {
            app.call("open_config_folder")
        }
    }
    MenuItem {
        text: "open run folder"
        onTriggered: {
            app.call("open_run_folder")
        }
    }
}

