import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.App 1.0
import DICE.Theme 1.0

Row {
    id: root

    property alias label: label.text
    property alias model: listView.model

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
    spacing: 10
    height: listView.height + 10
    opacity: enabled ? 1 : 0.5

    property PythonDropDownConnector dropDownConnector: PythonDropDownConnector {
        id: __dropDownConnector

        enabled: listView.enabled
    }

    BasicText {
        id: label

        width: !!parent.label ? (parent.width - parent.spacing)/2 : 0
        anchors.verticalCenter: parent.verticalCenter
        text: ""
//        wrapMode: Text.WrapAnywhere
        color: comboBox.activeFocus ? colors.highlightColor : "#666"
        verticalAlignment: Text.AlignVCenter
    }

    ExclusiveGroup {
        id: __exclusiveGroup
    }

    ListView {
        id: listView

        width: parent.width - label.width

        enabled: root.enabled && ! dropDownConnector.loadingModel
        model: dropDownConnector.model
        height: childrenRect.height

        delegate: RadioButton {
            exclusiveGroup: __exclusiveGroup
            text: model.text
            checked: dropDownConnector.currentIndex === index
            onClicked: {
                if (checked) dropDownConnector.currentIndex = index
            }
            style: RadioButtonStyle {}
            height: 20
        }

    }
}
