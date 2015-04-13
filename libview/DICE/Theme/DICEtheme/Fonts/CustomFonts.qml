import QtQuick 2.4
//import DICE.Style.Colors 1.0 as DiceColors

QtObject {
    property alias linkFont: linkText.font
    property alias standardCaption: standardCaptionText.font
    property alias standardDescription: standardDescriptionText.font
    property alias italicDescription: italicDescriptionText.font
    property alias boldDescription: boldText.font
    property alias smallPath: smallPathText.font
    property alias mainHeaderFont: mainHeaderText.font
    property alias secondHeaderFont: secondHeaderText.font
    property alias buttonFont: buttonFont.font
    property alias buttonFontThin: buttonFontThin.font
    property alias standardTextFont: standardTextFont.font
    property alias codeTextFont: codeTextFont.font

    property alias mainFont: mainFont.font
    property alias mainFontBold: mainFontBold.font

//    property var colors: DiceColors.CustomColors { }

    property list<Item> texts: [

        Text {
            id: smallPathText

            visible: false
            font.pixelSize: 13
            font.family: "Helvetica"
        },

        Text {
            id: linkText

            visible: false

            font.pixelSize: 13
            //font.bold: true
            font.family: "Helvetica"
        },

        Text {
            id: boldText

            visible: false

            font.pixelSize: 13
            font.bold: true
            font.family: "Helvetica"
        },

        Text {
            id: standardCaptionText

            visible: false

            font.family: "Helvetica"
            font.pixelSize: 14
        },

        Text {
            id: standardDescriptionText

            visible: false

            font.pixelSize: 13
            font.bold: false
            font.family: "Helvetica"
        },

        Text {
            id: italicDescriptionText

            visible: false

            font.pixelSize: 13
            font.bold: false
            font.family: "Helvetica"
        },

        Text{
            id: mainHeaderText

            FontLoader{
                id: terminalDosis
                source: Qt.resolvedUrl("TerminalDosis/TerminalDosis-ExtraLight.ttf")
            }

            FontLoader {
                id: robotoLight
                source: "roboto/Roboto-Light.ttf"
            }

            visible: false

//            font.letterSpacing: 0.25
//            font.pixelSize: 13
            font.bold: false
//            styleColor: "white"
//            antialiasing: true

//            color: "#82188C"
            color: colors.mainHeaderColor
            font.family: robotoLight.name
        },

        Text{
            id: secondHeaderText

            FontLoader{
                id: quickSand
                source: Qt.resolvedUrl("quicksand/Quicksand-Bold.otf")
            }
            visible: false
            font.letterSpacing: 0.25
            font.pixelSize: 16
            font.bold: false
            styleColor: "white"
            antialiasing: true
            font.family: quickSand.name
        },

        Text{
            id: buttonFont

            FontLoader{
                id: roboto
                source: Qt.resolvedUrl("roboto/Roboto-Regular.ttf")
            }
            visible: false
//            font.letterSpacing: 0.25
            font.pixelSize: 12
            font.bold: false
//            styleColor: "white"
            antialiasing: true
            font.family: roboto.name
//            font.family: "Roboto Regular"
            font.weight: Font.Normal
            renderType: Text.NativeRendering
            smooth: true
        },

        Text{
            id: mainFont

            FontLoader{
                id: robotoFont
                source: Qt.resolvedUrl("roboto/Roboto-Regular.ttf")
//                source: "qrc:DICE/Style/Fonts/roboto/RobotoReg.ttf"
            }
            visible: false
//            font.letterSpacing: 0.25
            font.pixelSize: 12
            font.bold: false
//            styleColor: "white"
            antialiasing: true
            font.family: robotoFont.name
//            font.family: "Roboto"
//            font.family: "Roboto Regular"
            font.weight: Font.Normal
            renderType: Text.NativeRendering
            smooth: true
        },

        Text{
            id: mainFontBold

            FontLoader{
                id: robotoFontBold
                source: Qt.resolvedUrl("roboto/RoboBold.ttf")
            }
            visible: false
//            font.letterSpacing: 0.25
            font.pixelSize: 12
            font.bold: false
//            styleColor: "white"
            antialiasing: true
            font.family: robotoFontBold.name
//            font.family: "Roboto Regular"
            font.weight: Font.Normal
            renderType: Text.NativeRendering
            smooth: true
        },

        Text{
            id: buttonFontThin

            FontLoader{
                id: robotoThin
                source: Qt.resolvedUrl("roboto/Roboto-Thin.ttf")
            }
            visible: false
            font.letterSpacing: 0.25
            font.pixelSize: 16
            font.bold: false
            styleColor: "white"
            antialiasing: true
            font.family: robotoThin.name
            renderType: Text.NativeRendering
            font.weight: Font.Normal
        },

        Text{
            id: standardTextFont

            FontLoader{
                id: robotoRegular
                source: Qt.resolvedUrl("roboto/Roboto-Regular.ttf")
            }
            visible: true
//            font.letterSpacing: 0.25
//            font.pixelSize: 16
//            font.bold: false
//            styleColor: "white"
//            antialiasing: true
            font.family: robotoRegular.name
            font.weight: Font.Normal
//            renderType: Text.NativeRendering
        },

        Text {
            id: codeTextFont

            FontLoader {
                id: codeFontRegular
                source: Qt.resolvedUrl("SourceCodePro/SourceCodePro-Regular.ttf")
            }
            visible: true
            font.family: codeFontRegular.name
            font.weight: Font.Normal
        }

    ]

}
