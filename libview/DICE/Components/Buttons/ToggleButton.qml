import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0

import DICE.Theme 1.0
import DICE.Components 1.0


FocusScope {
    id: root

    property alias label: label.text
    property alias uncheckedText: uncheckedText.text
    property alias checkedText: checkedText.text
    property alias checked: sw.checked

    width: parent.width
    height: column.height

    MouseArea {
       anchors.fill: parent
       onClicked: root.forceActiveFocus(Qt.MouseFocusReason)
    }

    Column {
        id: column

        width: parent.width

        CaptionText {
            id: label

            height: implicitHeight + 20
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: label.text !== ""
            color: root.activeFocus ? colors.highlightColor : colors.descriptionColor
        }

        Row {
            id: row

            width: parent.width
            height: Math.max(uncheckedText.implicitHeight, checkedText.implicitHeight, sw.height) + 10
            spacing: 10

            CaptionText {
                id: uncheckedText

                width: (parent.width - parent.spacing - sw.width)*0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: "No"
                anchors.verticalCenter: parent.verticalCenter
                color: root.activeFocus ? colors.mainTextColor : colors.descriptionColor

            }

            Switch {
                id: sw

                property color color: colors.highlightColor

                width: 40
                height: 15
                anchors.verticalCenter: parent.verticalCenter
                focus: true

                style: SwitchStyle {
                    id: switchStyle

                    property bool darkBackground: false
                    property color color: colors.highlightColor

                    handle: Item {
                        id: handleItem
                        width: 18
                        height: 18

                        Item {
                            id: handle

                            width: handleContent.width + buttonShadow.radius * 2
                            height: handleContent.height + buttonShadow.radius * 2
                            visible: false
                            anchors.centerIn: parent

                            Rectangle {
                                id: handleContent

                                width: handleItem.width
                                height: handleItem.height
                                color: control.enabled ? control.checked ? switchStyle.color  : darkBackground ? "#BDBDBD"
                                                                                                               : "#FAFAFA"
                                : darkBackground ? "#424242" : "#BDBDBD"
                                radius: width/2
                                anchors.centerIn: parent
                                anchors.margins: 2

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                            }
                        }

                        DropShadow {
                            id: buttonShadow

                            anchors.fill: source
                            cached: true
                            radius: 8
                            samples: 16
                            color: "#80000000"
                            smooth: false
                            source: handle
                        }
                    }
                    groove: Item {
                        width: 40
                        height: 18

                        Rectangle {
                            anchors.centerIn: parent

                            width: parent.width - 2
                            height: parent.height - 4

                            radius: height/2
                            color: control.enabled ? control.checked ? alpha(sw.color, 0.5)
                                                                     : darkBackground ? Qt.rgba(1, 1, 1, 0.26)
                                                                                      : Qt.rgba(0, 0, 0, 0.26)
                            : darkBackground ? Qt.rgba(1, 1, 1, 0.12)
                            : Qt.rgba(0, 0, 0, 0.12)

                            // From Material / Papyros
                            function alpha(color, alpha) {
                                // Make sure we have a real color object to work with (versus a string like "#ccc")
                                var realColor = Qt.darker(color, 1)

                                realColor.a = alpha

                                return realColor
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                        }
                    }
                }
            }

            CaptionText {
                id: checkedText

                width: (parent.width - parent.spacing - sw.width)*0.5
                height: implicitHeight + 20
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                text: "Yes"
                anchors.verticalCenter: parent.verticalCenter
                color: sw.checked ? colors.highlightColor : root.activeFocus ? colors.mainTextColor : colors.descriptionColor
            }
        }

        Item {
            height: 10
            width: parent.width
            visible: label.text !== ""
        }
    }
}
