import DICE.App 1.0

VectorField2D {
    id: root

    property string path

    property alias methodName: __xValueConnector.methodName
    property alias getMethod: __xValueConnector.getMethod
    property alias setMethod: __xValueConnector.setMethod
    property alias changeSignalMethod: __xValueConnector.changeSignalMethod

    property string helpPath: "foam/"+path

    onActiveFocusChanged: {
        if (activeFocus) {
            appWindow.helpPath = root.helpPath
        }
    }

    xValueConnector: FoamValueConnector {
        id: __xValueConnector
        enabled: xInputField.input.enabled
        path: root.path !== "" ? root.path+" 0" : "0"
    }

    yValueConnector: FoamValueConnector {
        enabled: yInputField.input.enabled
        path: root.path !== "" ? root.path+" 1" : "1"

        methodName: __xValueConnector.methodName
        getMethod: __xValueConnector.getMethod
        setMethod: __xValueConnector.setMethod
        changeSignalMethod: __xValueConnector.changeSignalMethod
    }
}
