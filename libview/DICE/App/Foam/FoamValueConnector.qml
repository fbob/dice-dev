import QtQuick 2.4

import DICE.App 1.0

PythonValueConnector {
    id: root

    methodName: "foam_var"

    property bool optional: false
    property bool optionalEnabled: false

    property bool notOptionalOrEnabled: !optional || optionalEnabled

    property alias path: root.callParameter

    function toggleOptionalEnabled() {
        if (path !== "") {
            app.call("set_invalid_or_remove_var", [path, !optionalEnabled], function(returnValue) {
                optionalEnabled = !optionalEnabled
            })
        }
    }

    function deleteFoamVar() {
        if (optionalEnabled) {
            optionalEnabled = false
            toggleOptionalEnabled()
        }
    }

    function __loadOptionalEnabled() {
        if (path !== "") {
            app.call("foam_var_exists", [path], function(returnValue) {
                optionalEnabled = returnValue
                if (returnValue)
                    load() // load the value if the foam_var exists
            })
        }
    }

    Component.onCompleted: {
        if (optional)
            __loadOptionalEnabled()
    }

    property Connections parentConn: Connections {
        target: parent
        onVisibleChanged: {
            if (root.optional)
                root.__loadOptionalEnabled()
        }
    }

    onEnabledChanged: {
        if (optional && !enabled)
            value = ""

        if (optional)
            __loadOptionalEnabled()
    }

    onPathChanged: {
        if (optional)
            __loadOptionalEnabled()
    }
}
