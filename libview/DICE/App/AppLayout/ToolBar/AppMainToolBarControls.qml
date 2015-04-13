import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.App 1.0

ToolBarGroup {
    title: "App Controls"

    Item {
        width: row.width
        height: parent.height - 10

        Rectangle {
            color: "#f4f4f4"
            width: parent.width
            height: 60*0.7
            radius: 15
            border.color: "#d2d2d2"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            id: row

            width: childrenRect.width
            height: parent.height

            Item {
                width: 40
                height: parent.height
            }

            Item {
                width: 60
                height: parent.height

                FloatingButton {
                    visible: app.status !== "running"
                    color: "#DF5745"
                    iconSource: "images/playArrow.svg"
                    action: Action {
                        onTriggered: dice.project.scheduleRun(app)
                    }
                }

                BusyIndicator {
                    anchors.fill: parent
                    visible: app.status === "running"
                    running: app.status === "running"
                    style: BusyIndicatorStyle {
                        indicator: Image {
                            visible: control.running
                            source: "images/ovalLoaderIndicator.svg"
                            sourceSize.width: 38
                            sourceSize.height: 38

                            RotationAnimator on rotation {
                                running: control.running
                                loops: Animation.Infinite
                                duration: 500
                                from: 0 ; to: 360
                            }
                        }
                    }
                }
            }

            Item {
                width: 40
                height: parent.height

                FloatingButton {
                    color: "#DF5745"
                    iconSource: "images/killRun.svg"
                    action: Action {
                        onTriggered: app.killProc()
                    }
                    visible: app.status === "running"
                }
            }
        }
    }
}
