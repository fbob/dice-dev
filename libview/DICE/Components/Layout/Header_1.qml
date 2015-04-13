import QtQuick 2.2
import QtQuick.Window 2.0

Text{

    property int userScale: 1
//    property int pixel: 30 * (Screen.pixelDensity/6.299213) * userScale

    font.pixelSize: 22 //18 //22
//    font.family: fonts.mainHeaderFont
    font.family:  fonts.buttonFont
    anchors.left: parent.left
//    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: 10
//    antialiasing: true
    font.letterSpacing: 0.5

}
