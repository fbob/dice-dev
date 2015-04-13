import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Column {
    property alias origin_path: origin.path
    property alias span_path: span.path

    width: parent.width

    Row {
        width: parent.width
        spacing: 10

        FlatButton {
            width: parent.width/3 - 2*parent.spacing/3
            text: "in X"
            onClicked: {
                span.xText = 0
                span.xEnabled = false
                span.yText = 1
                span.yEnabled = true
                span.zText = 1
                span.zEnabled = true
            }
        }
        FlatButton {
            width: parent.width/3 - 2*parent.spacing/3
            text: "in Y"
            onClicked: {
                span.xText = 1
                span.xEnabled = true
                span.yText = 0
                span.yEnabled = false
                span.zText = 1
                span.zEnabled = true
            }
        }
        FlatButton {
            width: parent.width/3 - 2*parent.spacing/3
            text: "in Z"
            onClicked: {
                span.xText = 1
                span.xEnabled = true
                span.yText = 1
                span.yEnabled = true
                span.zText = 0
                span.zEnabled = false
            }
        }
    }

    FoamVector {
        id: origin
        xLabel: "Origin X"
        yLabel: "Origin Y"
        zLabel: "Origin Z"
    }
    FoamVector {
        id: span
        xLabel: "Span in X [m]"
        yLabel: "Span in Y [m]"
        zLabel: "Span in Z [m]"
    }
    Caption { text: "One dimension must be 0 (no thickness)" }

    onEnabledChanged: {
        span.zText = 0
        span.zEnabled = false
    }
}
