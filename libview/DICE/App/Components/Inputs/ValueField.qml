import QtQuick 2.4
import QtQuick.Layouts 1.1

import DICE.App 1.0


FocusScope {
    id: root

    property alias label: input.label
    property alias text: input.text
    property alias input: input
    property alias readOnly: input.readOnly

    property alias methodName: __valueConnector.methodName
    property alias getMethod: __valueConnector.getMethod
    property alias setMethod: __valueConnector.setMethod
    property alias changeSignalMethod: __valueConnector.changeSignalMethod

    property alias callParameter: __valueConnector.callParameter

    property string dataType: "double"
    property var doubleValidator: DoubleValidator{ notation: "ScientificNotation" }
    property var intValidator: IntValidator{}
    property alias warnIfEmpty: input.warnIfEmpty

    property int intValue: 0
    property double doubleValue: 0.0

    width: parent.width
    height: childrenRect.height
    opacity: enabled ? 1 : 0.5

    property PythonValueConnector valueConnector: PythonValueConnector {
        id: __valueConnector
        enabled: input.enabled
    }

    InputField {
        id: input
        label: "X"

        focus: true

        width: parent.width

        floating: true
        centerLabel: false
        validator: dataType === "double" ? doubleValidator : intValidator

        text: {
            if ((text.indexOf(".") !==-1 || text.indexOf("e") !==-1 || text.indexOf("E") !== -1
                 || input.text === "-" || input.text === "+" || input.text === "."
                 || text.indexOf("0") !==-1) && root.focus && text.indexOf(",") ==-1)
                text
            else
                valueConnector.value !== undefined ? valueConnector.value : ""
        }

        onTextChanged: {
            if (input.text === "-" || input.text === "+" || input.text === ".")
                return

            if (input.text === "") {
                valueConnector.setValue("", dataType)
                return
            }

            if (dataType === "double") {
                doubleValue = parseFloat(input.text)
                valueConnector.setValue(doubleValue, dataType)
            }
            else {
                intValue = parseInt(input.text)
                valueConnector.setValue(intValue, dataType)
                if (isNaN(intValue)) {
                    valueConnector.setValue(input.text, dataType)
                }
            }
        }
    }
}
