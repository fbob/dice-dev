import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.Theme 1.0

FocusScope {
    id: root

    property bool inputEmpty: input.text == ""
    property bool floating: true
    property bool centerLabel : false
    property bool showWarning: false
    property bool warnIfEmpty: false
    property alias validator: input.validator
    property alias label: label.text
    property alias enabled: input.enabled
    property alias text: input.text
    property alias readOnly: input.readOnly

    signal editingFinished

    width: parent.width
    height: 48

    function undo() {
        input.undo()
    }

    opacity: root.readOnly ? 0.7 : 1

    MouseArea {
       anchors.fill: parent
       onClicked: root.forceActiveFocus(Qt.MouseFocusReason)
    }

    Rectangle {
        width: parent.width
        height: parent.height

        Rectangle {
            id: floatingLabelArea

            color: "transparent"
            width: parent.width
            height: parent.height/3
        }

        Rectangle {
            id: inputArea

            color: "transparent"
            width: parent.width
            height: parent.height/3
            anchors {
                top: floatingLabelArea.bottom
                left: parent.left
            }

            BodyText {
                id: label

                width: parent.width
                text: "Type something ..."
                visible: inputEmpty || floating
                horizontalAlignment: centerLabel ? Text.AlignHCenter : Text.AlignLeft
                anchors.top: parent.top
                anchors.topMargin: input.activeFocus && floating || !inputEmpty ? -root.height/3 : 0
                scalablePixelSize: input.activeFocus && floating || !inputEmpty ? 12 : 16
                color: input.activeFocus && floating ? colors.highlightColor : "#666"
                elide: Text.ElideRight

                transitions: Transition {
                    NumberAnimation { properties: "scalablePixelSize, anchors.topMargin"; easing.type: Easing.InOutQuad; duration: 150 }
                    ColorAnimation { duration: 300 }
                }
                maximumLineCount: 1
            }

            TextField {
                id: input

                focus: true
                activeFocusOnTab: true

                width: parent.width + 4
                height: parent.height + 4
                anchors {
                    left: parent.left
                    leftMargin: -4
                    bottom: parent.bottom
                    bottomMargin: -4
                }
                style: TextFieldStyle {
                    font: fonts.mainFont
                    textColor: "#000"
                    background: Rectangle {
                        color: "transparent"
                    }
                }
                onTextChanged: {
                    if (!focus) {
                        cursorPosition = 0
                    }
                }
                onEditingFinished: {
                    root.editingFinished()
                }

                onActiveFocusChanged: if (activeFocus) selectAll()
            }

            Rectangle {
                id: textHighlight

                width: input.activeFocus ? 0 : Math.min(label.text.length*10, label.width)
                height: parent.height
                color: colors.highlightColor
                visible: inputEmpty && input.activeFocus
                opacity: input.activeFocus ? 1 : 0.5
                Behavior on width {
                    NumberAnimation {easing.type: Easing.InOutQuad; duration: 150 }
                }
                Behavior on opacity {
                    NumberAnimation {easing.type: Easing.InOutQuad; duration: 200 }
                }
            }
        }

        Rectangle {
            id: warningsTextArea

            color: "transparent"
            width: parent.width
            height: parent.height/3
            anchors {
                top: inputArea.bottom
                left: parent.left
            }

            Rectangle {
                id: divider

                color: "#000"
                height: 1
                width: parent.width
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    bottomMargin: parent.height/2
                }
                opacity: root.enabled ? 0.6 : 0.1
            }

            Rectangle {
                id: dividerHighlight

                color: colors.highlightColor
                height: 2
                width: 0
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: parent.height/2
                }
            }

            Rectangle {
                visible: showWarning || (warnIfEmpty && inputEmpty )
                color: "transparent"
                width: parent.width
                height: parent.height/2
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                }

                BasicText {
                    text: "Warning!!!"
                    color: "#DA4336"
                    scalablePixelSize: 11
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.right: warningSign.left
                }

                FontAwesomeIcon {
                    id: warningSign

                    name: "WarningSign"
                    color: "#DA4336"
                    size: parent.height*0.7
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.bottom: parent.bottom
                }
            }
        }

        states: [
            State {
                name: "activeInputField"
                when: input.activeFocus
                PropertyChanges { target: dividerHighlight; width: parent.width }
            }
        ]
        transitions: Transition {
            NumberAnimation { property: "width"; easing.type: Easing.InOutQuad; duration: 200 }
        }
    }
}
