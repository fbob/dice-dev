import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.App 1.0
import DICE.Theme 1.0

FocusScope {
    id: root

    property alias path: valueConnector.path
    property alias methodName: valueConnector.methodName
    property alias getMethod: valueConnector.getMethod
    property alias setMethod: valueConnector.setMethod
    property alias changeSignalMethod: valueConnector.changeSignalMethod
    property alias label: label.text
    property alias text: valueField.text
    property alias optional: valueConnector.optional
    property alias dataType: valueField.dataType
    property alias readOnly: valueField.readOnly

    property string helpPath: "foam/"+path

    width: parent.width
    height: Math.max(valueField.height, label.height)

    function deleteFoamVar() {
        valueConnector.deleteFoamVar()
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            appWindow.helpPath = root.helpPath
        }
    }

    FoamValueConnector {
        id: valueConnector

        enabled: valueField.input.enabled
    }

    MouseArea {
       anchors.fill: parent
       onClicked: root.forceActiveFocus(Qt.MouseFocusReason)
    }


    Row {
        width: parent.width
        height: parent.height

        CheckBox {
            id: checkBox

            visible: valueConnector.optional
            checked: valueConnector.optionalEnabled
            onClicked: valueConnector.toggleOptionalEnabled()

            width: {
                if (checkBox.visible)
                    return parent.width/2  - space.width/2
                else
                    return parent.width/2 - 10
            }
            anchors.verticalCenter: parent.verticalCenter

            style: CheckBoxStyle {
                indicator: Rectangle {
                    implicitWidth: 16
                    implicitHeight: 16
                    radius: 3
                    border.color: control.activeFocus ? colors.highlightColor : "gray"
                    border.width: 1
                    Rectangle {
                        visible: control.checked
                        color: control.activeFocus ? colors.highlightColor : "#555"
                        border.color: control.activeFocus ? colors.highlightColor : "#333"
                        radius: 1
                        anchors.margins: 4
                        anchors.fill: parent
                    }
                }

                label: BasicText {
                    text: root.label
                    width: checkBox.width - 20
                    anchors.verticalCenter: parent.verticalCenter
                    color: control.activeFocus ? colors.highlightColor : "#666"
                    //                wrapMode: Text.WrapAnywhere
                    verticalAlignment: Text.AlignVCenter

                    transitions: Transition {
                        ColorAnimation { duration: 300 }
                    }
                }
            }
        }

        BasicText {
            id: label

            width: {
                if (checkBox.visible)
                    return parent.width/2 - checkBox.width - space.width/2
                else
                    return parent.width/2 - 10
            }
            visible: !checkBox.visible
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: valueField.activeFocus ? colors.highlightColor : "#333"
            verticalAlignment: Text.AlignVCenter

            transitions: Transition {
                ColorAnimation { duration: 300 }
            }
        }

        Item {
            id: space

            width: 20
            height: parent.height
        }

        ValueField {
            id: valueField

            label: ""
            focus: true

            enabled: root.enabled && valueConnector.notOptionalOrEnabled
            valueConnector: valueConnector
            warnIfEmpty: valueConnector.notOptionalOrEnabled

            width: {
                if (checkBox.visible)
                    return parent.width/2  - space.width/2
                else
                    return parent.width/2 - 10
            }

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
