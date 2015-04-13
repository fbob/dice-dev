import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.Theme 1.0

CheckBox {
    id: root

    property alias icon: iconImage.source
    property alias awesomeIconName: awesomeIcon.name
    property int size: 20

    width: size
    height: size


    // in order to use icon as an alias, we cannot use a regular indicator here,
    // but cheat by adding a Rectangle that acts as our indicator
    Rectangle {
        id: iconRect

        color: "transparent"
        anchors.fill: parent
        opacity: root.checked ? 1.0 : 0.5

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.OutElastic
                easing.amplitude: 3.0
                easing.period: 2.0
                duration: 500
            }
        }

        Image {
            id: iconImage

            anchors.fill: parent
            sourceSize.width: root.size
            source: ""
        }

        FontAwesomeIcon {
            id: awesomeIcon

            size: parent.height
            anchors.centerIn: parent
            visible: !!name
        }
    }

    style: CheckBoxStyle {
        indicator: Item {}
    }
}
