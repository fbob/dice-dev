import QtQuick 2.4
import QtQuick.Window 2.2

Item {
    property int scalablePixelSize: 14
    property real userScale: variables.userScale
    property int spp: parseInt(scalablePixelSize * 5.5/6.299213 * 0.8)
//    property int sps: userScale*((Screen.pixelDensity*25.4)/160)*scalablePixelSize
//    property int sps: scalablePixelSize
    Binding {
        target: parent
        property: "font.pixelSize"
        value: spp
    }
}
