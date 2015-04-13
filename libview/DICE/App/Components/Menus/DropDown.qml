import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Private 1.0

import DICE.App 1.0
import DICE.Theme 1.0


FocusScope {
    id: root

    property alias label: label.text
    property alias currentText: comboBox.currentText
    property alias currentIndex: comboBox.currentIndex
    property alias model: comboBox.model
    property alias textRole: comboBox.textRole

    property alias methodName: __dropDownConnector.methodName
    property alias getMethod: __dropDownConnector.getMethod
    property alias setMethod: __dropDownConnector.setMethod
    property alias changeSignalMethod: __dropDownConnector.changeSignalMethod

    property alias callParameter: __dropDownConnector.callParameter


    // Model fetching from python side
    // ===============================
    property alias modelMethodName: __dropDownConnector.modelMethodName
    property alias getModelMethod: __dropDownConnector.getModelMethod
    property alias changeSignalModelMethod: __dropDownConnector.changeSignalModelMethod

    property alias modelPath: __dropDownConnector.modelPath

    width: parent.width
    height: comboBox.height + 15
    opacity: enabled ? 1 : 0.5

    property PythonDropDownConnector dropDownConnector: PythonDropDownConnector {
        id: __dropDownConnector

        enabled: comboBox.enabled
    }

    MouseArea {
       anchors.fill: parent
       onClicked: root.forceActiveFocus(Qt.MouseFocusReason)
    }

    Row {
        spacing: 10

        width: parent.width
        height: parent.height

        BasicText {
            id: label

            width: !!root.label ? (parent.width - parent.spacing)/2 : 0
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: comboBox.activeFocus ? colors.highlightColor : "#333"
            verticalAlignment: Text.AlignVCenter
        }

        ComboBox {
            id: comboBox

            width: parent.width - label.width
            focus: true
            enabled: root.enabled && ! dropDownConnector.loadingModel
            model: dropDownConnector.model
            onCurrentIndexChanged: dropDownConnector.currentIndex = currentIndex
            currentIndex: dropDownConnector.currentIndex
            textRole: dropDownConnector.textRole
            anchors.verticalCenter: parent.verticalCenter

            style: ComboBoxStyle {
                background: Item {
                    implicitWidth: Math.round(TextSingleton.implicitHeight * 4.5)
                    implicitHeight: Math.max(28, Math.round(TextSingleton.implicitHeight * 1.2))
                    Rectangle {
                        anchors.fill: parent
                        anchors.bottomMargin: control.pressed ? 0 : -1
                        color: "#10000000"
                        radius: baserect.radius
                    }
                    Rectangle {
                        id: baserect
                        color: "#fff"
                        radius: TextSingleton.implicitHeight * 0.16
                        anchors.fill: parent
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: control.hovered || control.activeFocus ? "#47b" : "#666"
                            opacity: control.hovered || control.activeFocus ? 0.01 : 0
                            Behavior on opacity {NumberAnimation{ duration: 100 }}
                        }
                        Rectangle {
                            height: 2
                            width: parent.width
                            anchors.bottom: parent.bottom
                            color: control.hovered || control.activeFocus ? colors.highlightColor : colors.borderColor

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        FontAwesomeIcon {
                            id: sortIcon

                            name: "Sort"
                            color: control.hovered || control.activeFocus ? colors.highlightColor : "#666"
                            size: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            opacity: control.enabled ? 0.6 : 0.3

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }
                }

                label: Item {
                    implicitWidth: textItem.implicitWidth + 20
                    BasicText {
                        id: textItem

                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: 4
                            rightMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        text: control.currentText
                        color: control.hovered || control.activeFocus ? colors.highlightColor : "666"

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }
            }
        }
    }
}
