import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {
    property int zDepth: 1
    readonly property var parameters: {
        1: {
            black: 0.15,
            y_offset: 1,
            blur: 6
        },
        2: {
            black: 0.16,
            y_offset: 3,
            blur: 3
        },
        3: {
            black: 0.19,
            y_offset: 10,
            blur: 10
        },
        4: {
            black: 0.25,
            y_offset: 14,
            blur: 14
        },
        5: {
            black: 0.30,
            y_offset: 19,
            blur: 19
        }
    }
    anchors.fill: parent

    RectangularGlow {
        id: effect

        anchors.fill: parent
        anchors.topMargin: parameters[zDepth].y_offset || 1
        glowRadius: parameters[zDepth].blur || 4
        spread: 0.2
        color: "#000"
        cornerRadius: glowRadius/2
        opacity: parameters[zDepth].black || 0.12
    }


    Rectangle {
        id: rect

        color: "#fff"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: 2
        border.width: 1
        border.color: "#ccc"
    }
}
