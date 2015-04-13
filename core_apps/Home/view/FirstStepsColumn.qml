import QtQuick 2.3
import DICE.App 1.0

Rectangle {
    width: 200
    height: parent.height
    color: "transparent"
    Column {
        width: parent.width-20
        anchors.margins: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            height: 50
            width: 10
        }
        InfoCard {
            source: "images/desk_icon.svg"
            topic: "DESK"
            description: "Set up a case on the desk and just click the Run-Button"
        }
        Item {
            height: 20
            width: 10
        }
        InfoCard {
            source: "images/desk_icon.svg"
            topic: "Settings"
            description: "Configure DICE for your personal use"
        }
    }
}
