import DICE.App 1.0

ToggleButton {
    id: root

    property string path

    property alias methodName: __valueConnector.methodName
    property alias getMethod: __valueConnector.getMethod
    property alias setMethod: __valueConnector.setMethod
    property alias changeSignalMethod: __valueConnector.changeSignalMethod

    property alias callParameter: __valueConnector.callParameter

    property string helpPath: "foam/"+path

    onActiveFocusChanged: {
        if (activeFocus) {
            appWindow.helpPath = root.helpPath
        }
    }

    valueConnector: FoamValueConnector {
        id: __valueConnector
        path: root.path
        enabled: root.enabled
    }
}
