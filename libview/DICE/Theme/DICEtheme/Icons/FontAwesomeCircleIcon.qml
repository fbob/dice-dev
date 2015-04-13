import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import DICE.Style.Icons 1.0 as DiceIcons


Rectangle {
    id: root

    property color buttonColor: "#3B8DBD"
    property var icon
    property bool centerLeft  : false

    radius: 100
    color: buttonColor
    clip: true

    Rectangle {
        x:2.5
        y:2.5
        width: parent.width   - 5
        height: parent.height - 5
        radius: parent.radius
        color: control.hovered ? Qt.darker(root.buttonColor, 5) : "#eee"
        opacity: control.hovered || control.activeFocus ? 0.5 : 1
        Behavior on opacity {NumberAnimation{ duration: 500 }}
    }

    DiceIcons.FontAwesomeIcon {
        id: icon
        icon: root.icon
        iconColor: control.hovered ? "white" : root.buttonColor
            opacity: control.hovered || control.activeFocus ? 0.8 : 1
            Behavior on opacity {NumberAnimation{ duration: 800 }}
        iconSize: root.width/3
        x: {
            if (root.centerLeft)
                parent.width/2  - iconSize/10
            else
                parent.width/2  + iconSize/10
        }
        y: parent.height/2
    }
}
