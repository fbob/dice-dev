import QtQuick 2.4

import DICE.App 1.0
import DICE.Components 1.0 as DC

DC.ToggleButton {
    id: root

    property alias methodName: __valueConnector.methodName
    property alias getMethod: __valueConnector.getMethod
    property alias setMethod: __valueConnector.setMethod
    property alias changeSignalMethod: __valueConnector.changeSignalMethod

    property alias callParameter: __valueConnector.callParameter

    property PythonValueConnector valueConnector: PythonValueConnector {
        id: __valueConnector

        enabled: root.enabled
    }

    property var valueConnectorValue: valueConnector.value

    onValueConnectorValueChanged: {
        if (checked !== valueConnectorValue)
            checked = valueConnectorValue
    }

    onCheckedChanged: {
        valueConnector.setValue(root.checked)
    }
}
