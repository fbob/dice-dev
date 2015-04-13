import QtQuick 2.3
import QtQuick.Window 2.0

Item {
    property int scalableLineHeight: 13
    property real userScale: variables.userScale
    property int slh: parseInt(scalableLineHeight* 5.5/6.299213 * 1)
//    property int slh: userScale*((Screen.pixelDensity*25.4)/160)*scalableLineHeight
//    property int slh: scalableLineHeight
    Binding {
        target: parent
        property: "lineHeight"
        value: slh
    }
}
