import QtQuick 2.4

BasicText {
    property bool bold : false

    font.weight: bold ? Font.Bold : Font.Normal
    font.letterSpacing: 0
    opacity: 0.87
    scalablePixelSize: 15
    scalableLineHeight: 29
    lineHeightMode: Text.FixedHeight
}
