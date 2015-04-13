import QtQuick 2.4

import DICE.App.Renderer 1.0

Item {
    id: root
    anchors.fill: parent

    property Item renderer: null
    property var visApp

    property Component fboRenderer: FBORenderer {
        transform: Scale { xScale: 1; yScale: -1; origin.x: width / 2; origin.y: height / 2; }
        MouseArea {
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true
                anchors.fill: parent
                onWheel: renderer.mouseWheel(wheel.angleDelta.y)
                onPressed: renderer.mousePressed(mouse.buttons)
                onReleased: renderer.mouseReleased(mouse.buttons)
                onMouseXChanged: renderer.mouseMoved(mouse.x, mouse.y)
                onMouseYChanged: renderer.mouseMoved(mouse.x, mouse.y)
                onPositionChanged: renderer.mouseMoved(mouse.x, mouse.y)
                onClicked: renderer.mouseClicked(mouse.buttons, mouse.x, mouse.y)
            }
    }

    Loader {
        id: loader

        anchors.fill: parent
        sourceComponent: fboRenderer
        onItemChanged: {
            item.app = root.visApp
            root.renderer = item
        }
        asynchronous: true
//        active: false
    }

    onVisibleChanged: {
        loader.item = undefined
        root.renderer = undefined
    }

//    Timer {
//        id: itemChangePause
//        interval: 30
//        onTriggered: {
//            loader.item.app = root.visApp
//            root.renderer = loader.item
//        }
//    }

//    Timer {
//        id: setFborenderer
//        interval: 30
//        onTriggered: {
//            loader.sourceComponent = fboRenderer
//        }
//    }

//    onVisibleChanged: {
//        if (!visible) {
//            loader.sourceComponent = undefined
//        }
//        else
//            setFborenderer.start()
//    }

//    states: [
//        State {
//            name: "active"
//            when: root.visible
//            PropertyChanges {
//                target: loader
//                active: true
//            }
//        },

//        State {
//            name: "notActive"
//            when: !root.visible
//            PropertyChanges {
//                target: loader
//                active: false
//            }
//        }
//    ]

    function deleteRenderer() {
        renderer.deleteLater()
    }


    // keyboard focus is only on the main Rectangle -> we must process key events for the renderer outside
    function keyOnPressed(event) {
        switch (event.key) {
        case Qt.Key_Left:
            renderer.move(0.5,0,0);
            break;
        case Qt.Key_Right:
            renderer.move(-0.5,0,0);
            break;
        case Qt.Key_Up:
            renderer.pitch(-1);
            break;
        case Qt.Key_Down:
            renderer.pitch(1);
            break;
        case Qt.Key_A:
            renderer.yaw(1);
            break;
        case Qt.Key_D:
            renderer.yaw(-1);
            break;
        case Qt.Key_Q:
            renderer.roll(1);
            break;
        case Qt.Key_E:
            renderer.roll(-1);
            break;
//        case Qt.Key_X:
//            test();
//            break;
        case Qt.Key_Y:
            renderer.representation = Renderer.Surface
            break;
        case Qt.Key_X:
            renderer.representation = Renderer.Wireframe
            break;
        case Qt.Key_C:
            renderer.representation = Renderer.Points
            break;
        case Qt.Key_V:
            renderer.frontfaceCulling = !renderer.frontfaceCulling
            break;
        case Qt.Key_B:
            renderer.backfaceCulling = !renderer.backfaceCulling
            break;
        }
    }

    function loadFile(url) {
        renderer.loadFile(url)
    }

    function test(){
        renderer.setBackground()
    }
}
