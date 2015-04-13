import QtQuick 2.4


// TODO: Remove this file and put everything into dice.theme python class
QtObject {
    property color lighterBorderColor: "#d2d2d2"
    property color mainTextColor: "#404040"
    property color mainBackgroundColor: "#f4f4f4"
    property color secondBackgroundColor: "#f9f9f9"
    property color descriptionColor: "#666"
    property color secondHeaderColor: "#4D6684"
    property color highlightColor: "#E74700"

    property color naviHeaderColor: "#45B959"
    property color mainHeaderColor: "#3D3D3D"

    property color warningColor: "#FF3950"
    property color errorColor: "#d32f2f"

    property color mainNaviShadowColor: "#e2e2e2"
    property color mainNaviBackgroundColor: "#fff"

    property color windowTabBarColor: "#2095F1"//#fafafa"
    property color windowToolBarFrameColor: "#fafafa"
    property color windowTabBarTextColor: "#fff"//#333"

    property color windowToolBarTextColor: "#333"
    property color windowToolBarGroupTextColor: "#5a5a5a"
    property color windowTabBarSelectedButtonText: "#fff"

    property color bottomControlsColor: "#e9e9e9"

    property color iconColor: "#333"

    // MenuButton
    property color menuButtonGridColor: "#d3d3d3"

    // MenuHeader
    property color menuHeaderBackgroundColor: "#fff"

    // App
    property var appStatusColors: {
        "idle" : "#798690",
        "preparing" : "#5D00FF",
        "running"   : "#1AA7FF",
        "finished"  : "green",
        "error"     : "#FF1A13"
    }

    // StreamItem
    property color streamItemFocusedColor: "#F4FF8F"
    property color streamItemBackgroundColor: "#FFF"


    property color borderColor: dice.theme.color.border
}
