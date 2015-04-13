import QtQuick 2.2
import DICE.Style.Borders 1.0 as DiceBorders
import DICE.Style.Elements 1.0 as DiceElements

Rectangle{
    property alias text: descriptionText.text
    width: parent.width
    height: descriptionText.height
    color: "transparent"

    Text{
        id: descriptionText
        font.pixelSize: 11
        font.letterSpacing: 0.5
        font.family: fonts.standstandardDescription
        color: colors.descriptionColor
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        antialiasing: true
        wrapMode: Text.WordWrap
        width: parent.width
    }
}
