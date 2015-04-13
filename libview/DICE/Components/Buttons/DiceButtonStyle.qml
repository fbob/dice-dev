import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Private 1.0

Style {
    id: buttonstyle

    /*! Dice: Additional information */
    property color labelColor: "white"
//    property color labelColor: "#333"

    /*! The \l Button attached to this style. */
    readonly property Button control: __control

    /*! \internal */
    property var __syspal: SystemPalette {
        colorGroup: control.enabled ?
                        SystemPalette.Active : SystemPalette.Disabled
    }

    /*! The padding between the background and the label components. */
    padding {
        top: 4
        left: 4
        right:  control.menu !== null ? Math.round(TextSingleton.implicitHeight * 0.5) : 4
        bottom: 4
    }


    /*! This defines the background of the button. */
    property Component background: Item {
        implicitWidth: Math.round(TextSingleton.implicitHeight * 4.5)
        implicitHeight: Math.max(30, Math.round(TextSingleton.implicitHeight * 1.2))
        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: control.pressed ? 0 : -1
            color: "#10000000"
//            radius: baserect.radius
        }
        Rectangle {
            id: baserect
//            gradient: Gradient {
//                GradientStop {color: control.pressed ? "#aaa" : "#fefefe" ; position: 0}
//                GradientStop {color: control.pressed ? "#ccc" : "#e3e3e3" ; position: control.pressed ? 0.1: 1}
//            }
//            color: control.pressed ? "#3276B1" : control.activeFocus ? "#cdd" :  "#428BCA"
//            color: control.pressed ? "#60B508" : control.activeFocus ? "#60B508" :  "#60B508"
            color: control.pressed ? "#60B508" : control.activeFocus ? "white" :  "#59941A"
//            color: "#fff"
            opacity: control.enabled ? 1 : 0.5
//            color: "transparent"
//            BorderImage {
//                anchors.fill: parent
//                source: "images/full_button.png"
//                anchors.centerIn: parent
//                anchors.margins: -1
//                anchors.bottomMargin: -2
//                anchors.rightMargin: 0

//                border.left: 4
//                border.right: 4
//                border.top: 4
//                border.bottom: 4
//            }
//            radius: TextSingleton.implicitHeight * 0.16
            anchors.fill: parent
//            border.color: control.activeFocus ? "#47b" : "#999"
//            border.color: control.activeFocus ? "#28838C" : "#285E8E"
            border.color: "#333"
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
//                color: control.activeFocus ? "#47b" : "white"
                color: control.activeFocus ? "#60B508" : "white"
                opacity: control.hovered || control.activeFocus ? 0.1 : 0
                Behavior on opacity {NumberAnimation{ duration: 100 }}
            }

//            Rectangle {
//                anchors.fill: parent
////                anchors.margins: 1
//                color: "transparent"
//                antialiasing: true
//                visible: !control.pressed
//                border.color: "#285E8E"
//                radius: parent.radius
//            }
//            Rectangle{
//                radius: parent.radius
//                anchors.left: parent.left
//                anchors.right: parent.right
//                anchors.rightMargin: 2
//                anchors.leftMargin: 2
//                height: 1
//                anchors.top: parent.top
//                anchors.topMargin: 1
//                color: "#d2d2d2"
//                opacity: 0.5
//            }
        }
//        Image {
//            id: imageItem
//            visible: control.menu !== null
//            source: "images/full_button.png"
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.right: parent.right
//            anchors.rightMargin: padding.right
//            opacity: control.enabled ? 0.6 : 0.5
//        }
    }


    /*! This defines the label of the button.  */
    property Component label: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 2
            Image {
                source: control.iconSource
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                FontLoader{
                    id: terminalDosis
                    source: "qrc:DICE/Style/Fonts/TerminalDosis/TerminalDosis-SemiBold.ttf"
                }
                renderType: Text.NativeRendering
                anchors.verticalCenter: parent.verticalCenter
                text: control.text
//                color: __syspal.text
                color: labelColor
                styleColor: "white"
                antialiasing: true
                font.pixelSize: 18
                font.family: terminalDosis.name
//                font.bold: true
                font.letterSpacing: 1.5
            }
        }
    }

    /*! \internal */
    property Component panel: Item {
        anchors.fill: parent
        implicitWidth: Math.max(labelLoader.implicitWidth + padding.left + padding.right, backgroundLoader.implicitWidth)
        implicitHeight: Math.max(labelLoader.implicitHeight + padding.top + padding.bottom, backgroundLoader.implicitHeight)

        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: background
        }

        Loader {
            id: labelLoader
            sourceComponent: label
            anchors.fill: parent
            anchors.leftMargin: padding.left
            anchors.topMargin: padding.top
            anchors.rightMargin: padding.right
            anchors.bottomMargin: padding.bottom
        }
    }


}
