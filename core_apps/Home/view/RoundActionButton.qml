import QtQuick 2.4
import QtGraphicalEffects 1.0

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    id: root

    property bool buttonToggle: false
    property bool buttonHovered: false

    Item {
        id: logoButton

        width: buttonContent.width + buttonShadow.radius * 2
        height: buttonContent.height + buttonShadow.radius * 2

        Rectangle {
            id: buttonContent
            width: 59
            height: 59
            color: "#fff"
            radius: width/2
            anchors.centerIn: parent
            anchors.margins: 3

            Image {
                id: diceLogo
                source: buttonHovered ? "images/dice_logo_hovered.png":"images/dice_logo.png"
                width: 40
                height: 40
                anchors.centerIn: parent
                antialiasing: true
            }
        }

        Rectangle {
            id: cardContent

            width: 59
            height: 59
            color: "#fff"
            radius: width/2
            anchors.centerIn: parent
            anchors.margins: 3
            opacity: 0

            Column {
                id: column

                width: parent.width

                Rectangle {
                    width: parent.width
                    height: 50

                    BottomBorder {}

                    Row {
                        width: parent.width
                        height: parent.height

                        Item {
                            width: 15
                            height: parent.height
                        }
                        Image {
                            sourceSize.height: parent.height/2
                            source: "images/dice_logo_text.svg"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Item {
                            width: 15
                            height: parent.height
                        }
                        HeadlineText {
                            text: "Dynamic Interface for Computation and Evaluation"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 4
                        }
                    }
                }
                PaddedScrollViewRect {
                    id: scrollView

                    width: parent.width
                    height: 540
                    contentHeight: 540

                    Column {
                        id: col

                        width: scrollView.width
                        Item {
                            width: 520
                            height: 180

                            Row {
                                width: parent.width
                                height: parent.height
                                spacing: 10

                                Image {
                                    source: "images/DICEgui.png"
                                    width: parent.width/3 - parent.spacing/2
                                    height: parent.height
                                    fillMode: Image.PreserveAspectFit
                                }

                                BasicText {
                                    width: parent.width*2/3 - parent.spacing/2
                                    height: parent.height
                                    text: "Optimized workflow for repeated numerical simulations. Following modern UI design."
                                    verticalAlignment: Text.AlignVCenter
                                    color: "#666"
                                }
                            }
                        }
                        Item {
                            width: 520
                            height: 180

                            Row {
                                width: parent.width
                                height: parent.height
                                spacing: 10

                                Image {
                                    source: "images/DICEframework.png"
                                    width: parent.width/3 - parent.spacing/2
                                    height: parent.height
                                    fillMode: Image.PreserveAspectFit
                                }

                                BasicText {
                                    width: parent.width*2/3 - parent.spacing/2
                                    height: parent.height
                                    text: "Modular application architecture. Keeping the character of typical open source projects to insure a faster development and maintainability. Easy use of multiple versions with no conflicts."
                                    verticalAlignment: Text.AlignVCenter
                                    color: "#666"
                                }
                            }
                        }
                        Item {
                            width: 520
                            height: 180

                            Row {
                                width: parent.width
                                height: parent.height
                                spacing: 10

                                Image {
                                    source: "images/DICEengine.png"
                                    width: parent.width/3 - parent.spacing/2
                                    height: parent.height
                                    fillMode: Image.PreserveAspectFit
                                }

                                BasicText {
                                    width: parent.width*2/3 - parent.spacing/2
                                    height: parent.height
                                    text: "Built with QML, Python and OpenFOAM to simplify the developement process."
                                    verticalAlignment: Text.AlignVCenter
                                    color: "#666"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    DropShadow {
        id: buttonShadow

        anchors.fill: source
        cached: true
        radius: 8.0
        samples: 16
        color: "#80000000"
        smooth: false
        source: logoButton

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                buttonToggle = !buttonToggle
            }
            onEntered: {
                buttonHovered = !buttonHovered
            }
            onExited: {
                buttonHovered = !buttonHovered
            }
            propagateComposedEvents: false
        }

        states: [
            State {
                name: "dialog"
                when: buttonToggle
                PropertyChanges { target: buttonContent; width: 640; height: 600; radius: 2; color: "white"; opacity: 0}
                PropertyChanges { target: cardContent; width: 640; height: 600; radius: 2; color: "white"; opacity: 1}
                PropertyChanges { target: logoButton; anchors.leftMargin: (root.width - buttonContent.width)/2; anchors.topMargin: 64 }
            },
            State {
                name: "button"
                when: buttonToggle
                PropertyChanges { target: buttonContent; color: "#fff"}
            },
            State {
                name: "buttonHovered"
                when: buttonHovered
                PropertyChanges {
                    target: buttonContent
                    color: colors.highlightColor
                }
            }
        ]
        transitions: Transition {
            NumberAnimation {
                properties: "width,height,radius,anchors.leftMargin,anchors.topMargin, opacity"
                easing.type: Easing.InOutQuad
                duration: 300
            }
            ColorAnimation { duration: 300 }
        }
    }
}

