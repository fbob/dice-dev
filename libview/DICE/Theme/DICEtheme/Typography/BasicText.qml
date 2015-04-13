import QtQuick 2.4

Text {
    property alias scalablePixelSize: sf.scalablePixelSize
    property alias scalableLineHeight: slh.scalableLineHeight
    ScalableFont {
        id: sf
        scalablePixelSize: 15
    }
    ScalableLineHeight {
        id: slh
        scalableLineHeight: 16
    }
    lineHeightMode: Text.FixedHeight
    font.capitalization: Font.MixedCase
    font.weight: Font.Normal
    renderType: Text.QtRendering
    antialiasing: true
    smooth: true
    color: "#000"
    wrapMode: Text.WordWrap
    font.wordSpacing: 3
    font.family: fonts.mainFont
    textFormat: Text.StyledText
    font.letterSpacing: 0.6
}
