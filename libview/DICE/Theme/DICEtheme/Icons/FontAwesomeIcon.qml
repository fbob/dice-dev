import QtQuick 2.4

import DICE.Theme 1.0

Item {
    id: root

    property string name
    property string icon: FontAwesome.Icon.hasOwnProperty(name) ? FontAwesome.Icon[name] : ""
    property color color: colors.iconColor
    property int size: 10

    width: size + 2
    height: size + 2

    // Load the "FontAwesome" font for the monochrome icons.
    FontLoader { source: Qt.resolvedUrl("font-awesome-4.0.3/fonts/fontawesome-webfont.ttf") }

    Text {
        anchors.centerIn: parent
        font.family: "FontAwesome"
        font.pointSize: size
        text: root.icon
        color: root.color

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
