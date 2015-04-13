import QtQuick 2.4
import QtQuick.Layouts 1.1

import DICE.App 1.0

FocusScope {
    id: root

    property alias xLabel: xField.label
    property alias yLabel: yField.label
    property alias zLabel: zField.label
    property alias xText: xField.text
    property alias yText: yField.text
    property alias zText: zField.text

    property alias methodName: __xValueConnector.methodName
    property alias getMethod: __xValueConnector.getMethod
    property alias setMethod: __xValueConnector.setMethod
    property alias changeSignalMethod: __xValueConnector.changeSignalMethod

    property string dataType: "double"
    property string xDataType: dataType
    property string yDataType: dataType
    property string zDataType: dataType
    property var doubleValidator: DoubleValidator{}
    property var intValidator: IntValidator{}

    property bool readOnly: false
    property bool xReadOnly: readOnly
    property bool yReadOnly: readOnly
    property bool zReadOnly: readOnly

    property var callParameter

    property alias xInputField: xField
    property alias yInputField: yField
    property alias zInputField: zField

    property alias xEnabled: xField.enabled
    property alias yEnabled: yField.enabled
    property alias zEnabled: zField.enabled

    property var xValueConnector: PythonValueConnector {
        id: __xValueConnector
        enabled: xField.input.enabled
        callParameter: !!parent.callParameter ? parent.callParameter+" 0" : "0"
    }

    property var yValueConnector: PythonValueConnector {
        id: __yValueConnector
        enabled: yField.input.enabled
        callParameter: !!parent.callParameter ? parent.callParameter+" 1" : "1"

        methodName: __xValueConnector.methodName
        getMethod: __xValueConnector.getMethod
        setMethod: __xValueConnector.setMethod
        changeSignalMethod: __xValueConnector.changeSignalMethod
    }

    property var zValueConnector: PythonValueConnector {
        id: __zValueConnector
        enabled: zField.input.enabled
        callParameter: !!parent.callParameter ? parent.callParameter+" 2" : "2"

        methodName: __xValueConnector.methodName
        getMethod: __xValueConnector.getMethod
        setMethod: __xValueConnector.setMethod
        changeSignalMethod: __xValueConnector.changeSignalMethod
    }

    width: parent.width
    height: row.height
    opacity: enabled ? 1 : 0.5

    MouseArea {
       anchors.fill: parent
       onClicked: root.forceActiveFocus(Qt.MouseFocusReason)
    }

    RowLayout {
        id: row

        spacing: 10
        width: parent.width
        height: childrenRect.height

        ValueField {
            id: xField
            label: "X"

            Layout.fillWidth: true
            valueConnector: xValueConnector
            dataType: root.xDataType
            doubleValidator: root.doubleValidator
            intValidator: root.intValidator
            readOnly: root.xReadOnly
        }

        ValueField {
            id: yField
            label: "Y"

            Layout.fillWidth: true
            valueConnector: yValueConnector
            dataType: root.yDataType
            doubleValidator: root.doubleValidator
            intValidator: root.intValidator
            readOnly: root.yReadOnly
        }

        ValueField {
            id: zField
            label: "Z"

            Layout.fillWidth: true
            valueConnector: zValueConnector
            dataType: root.zDataType
            doubleValidator: root.doubleValidator
            intValidator: root.intValidator
            readOnly: root.zReadOnly
        }
    }
}
