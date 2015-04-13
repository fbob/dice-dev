import QtQuick 2.4

FlatButton {
    id: root

    raised: true
    zDepth: 1

    PropertyAnimation {
        id: anim1

        target: root
        property: "zDepth"
        running: root.pressed
        from: root.zDepth
        to: 5
        duration: 100
        easing.type: Easing.InOutQuad
        alwaysRunToEnd: true
    }

    PropertyAnimation {
        id: anim2

        target: root
        property: "zDepth"
        running: !root.pressed
        from: root.zDepth
        to: 1
        duration: 100
        easing.type: Easing.InOutQuad
        alwaysRunToEnd: true
    }
}
