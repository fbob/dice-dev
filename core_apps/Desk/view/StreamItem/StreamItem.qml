import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0

import DICE.Components 1.0
import DICE.Theme 1.0

Item {
    id: root
    objectName: "StreamItem"

    property var app
    property bool streamItemMoving: false
    property int zDepth: 1
    property int zIndex
    property alias inputDock: _inputDock
    property alias outputDock: _outputDock
    property bool isGettingRenamed: false

    width: 220
    height: 120

    Drag.hotSpot.x: 10
    Drag.hotSpot.y: 10

    x: (!!app)?app.x:0
    y: (!!app)?app.y:0

    onXChanged: {
        if (!!app) {
            if (x < 0)
                x = 0
            if (x > workSpace.width - root.width)
                x = workSpace.width - root.width
            app.x = x
        }
    }

    onYChanged: {
        if (!!app) {
            if (y < 0)
                y = 0
            if (y > workSpace.height - root.height)
                y = workSpace.height - root.height
            app.y = y
        }
    }

    Component.onCompleted: {
        if (!!app && app.name !== "") {
            app.deskItem = root
        }
    }

    onAppChanged: {
        if (!app) {
            root.destroy()
        }
    }

    RightClickMenu { id: rightClickMenu }

    Item {
        id: streamItemBackground

        property color backgroundColor: parent.activeFocus ?  colors.streamItemFocusedColor : colors.streamItemBackgroundColor

        anchors.fill: parent

        RectShadow {
            zDepth: root.zDepth
            opacity: 0.7
        }

        Rectangle {
            color: parent.backgroundColor
            anchors.fill: parent
            radius: 2
            border.width: 1
            border.color: "#ccc"
        }
    }

    Item {
        id: streamItemInformation

        anchors.fill: parent
        anchors.margins: 10

        Column {
            id: col

            width: parent.width
            spacing: 15

            Row {
                width: parent.width
                height: 25

                Rectangle {
                    id: letterBox

                    width: height
                    height: parent.height
                    color: "#fff"
                    border.width: 1
                    border.color: colors.borderColor
                    radius: 4
                    opacity: 0.8

                    Text {
                        text: instanceLabelInput.text.charAt(0)
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "#515151"
                        font.pixelSize: 10
                    }
                }
                Item {
                    id: space
                    width: 10
                    height: 1
                }
                Item {
                    id: instanceLabel

                    width: parent.width - letterBox.width - space.width
                    height: parent.height

                    BasicText {
                        id: instanceLabelText

                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        scalablePixelSize: 18
                        scalableLineHeight: 20
                        elide: Text.ElideRight
                        text: (!!app && !!app.instanceName)
                              ? app.instanceName:""
                        visible: !instanceLabelInput.visible
                    }
                    TextField {
                        id: instanceLabelInput

                        visible: root.isGettingRenamed
                        anchors.fill: parent
                        font.pixelSize: 14
                        enabled: root.isGettingRenamed
                        readOnly: !enabled

                        text: (!!app && !!app.instanceName)
                              ? app.instanceName:""

                        onReadOnlyChanged: {
                            if (!readOnly) {
                                selectAll()
                                forceActiveFocus()
                            }
                        }
                        onTextChanged: {
                            var currentText = instanceLabelInput.text
                            checkIfNameValid(currentText)
                        }
                        onEditingFinished: {
                            var newName = instanceLabelInput.text
                            if (checkIfNameValid(newName)) {
                                app.renameInstanceName(newName)
                                root.isGettingRenamed = false
                            }
                            else
                                selectAll()
                        }
                        Keys.onEscapePressed: {
                            if (!readOnly && focus) {
                                undo()
                                root.isGettingRenamed = false
                            }
                        }
                        Keys.onTabPressed: {
                            if (!readOnly && focus) {
                                undo()
                                root.isGettingRenamed = false
                            }
                        }

                        function checkIfNameValid(name) {
                            var regExp = /^[^\\/?%*:|"<>]+$/
                            if (regExp.test(name)) {
                                instanceLabelInput.textColor = "black"
                                return true
                            }
                            else
                            {
                                instanceLabelInput.textColor = "red"
                                return false
                            }
                        }
                        style: TextFieldStyle {
                            background: Rectangle {
                                color: "#eee"
                                visible: root.isGettingRenamed
                            }
                            renderType: Text.QtRendering
                        }
                    }
                }
            }

            Row {
                width: parent.width
                height: 10

                BasicText {
                    text: "app: "
                    scalablePixelSize: 14
                }
                Item {
                    width: 10
                    height: 1
                }
                BasicText {
                    id: appNameLabel
                    scalablePixelSize: 14
                    text: (!!app && !!app.name)
                            ? app.name:""
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    color: colors.highlightColor
                }
            }

            Row {
                width: parent.width
                height: 10

                BasicText {
                    text: "status: "
                    scalablePixelSize: 14
                }
                Item {
                    width: 10
                    height: 1
                }
                BasicText {
                    id: statusLabel
                    text: (!!app)?app.status:""
                    scalablePixelSize: 14
                    color: colors.appStatusColors[app.status]
                }
            }

            Row {
                width: parent.width
                height: 10

                Row {
                    id: statusBox

                    height: parent.height
                    width: 80

                    Rectangle {
                        height: parent.height
                        width: height
                        radius: width/2
                        color: app.status === "error" ? colors.appStatusColors["error"] : "transparent"
                        border.width: 2
                        border.color: colors.borderColor
                    }
                    Rectangle {
                        width: 5
                        height: 2
                        color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        height: parent.height
                        width: height
                        radius: width/2
                        color: app.status === "idle" ? colors.appStatusColors["idle"] : "transparent"
                        border.width: 2
                        border.color: colors.borderColor
                    }
                    Rectangle {
                        width: 10
                        height: 2
                        color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        height: parent.height
                        width: height
                        radius: width/2
                        color: app.status === "preparing" || app.status === "running" || app.status === "finished"
                               ? colors.appStatusColors["preparing"] : "transparent"
                        border.width: 2
                        border.color: colors.borderColor
                    }
                    Rectangle {
                        width: 5
                        height: 2
                        color: colors.borderColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        height: parent.height
                        width: height
                        radius: width/2
                        color: !!app && (app.status === "running" || app.status === "finished")
                               ? colors.appStatusColors["running"] : "transparent"
                        border.width: 2
                        border.color: colors.borderColor
                    }
                    Rectangle {
                        width: 5
                        height: 2
                        color: colors.borderColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        height: parent.height
                        width: height
                        radius: width/2
                        color: app.status === "finished" ? colors.appStatusColors["finished"] : "transparent"
                        border.width: 2
                        border.color: colors.borderColor
                    }
                }

                ProgressBar {
                    width: parent.width - statusBox.width
                    height: parent.height
                    visible: app.status === "running"
                    indeterminate: true

                    style: ProgressBarStyle {
                        background: Item {}
                        progress: Rectangle {
                            color: colors.borderColor
                            border.color: colors.highlightColor

                            Item {
                                anchors.fill: parent
                                anchors.margins: 1
                                visible: control.indeterminate
                                clip: true
                                Row {
                                    id: progressBarRow

                                    Repeater {
                                        Rectangle {
                                            color: index % 2 ? colors.highlightColor : colors.borderColor
                                            width: 20 ; height: control.height
                                        }
                                        model: control.width / 20 + 2
                                    }
                                    Timer {
                                        running: app.status === "running"
                                        interval: 50
                                        repeat: true
                                        onTriggered: {
                                            progressBarRow.x --
                                            if (progressBarRow.x === -40)
                                                progressBarRow.x = 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: streamItem_mouseArea

        enabled: !root.isGettingRenamed
        anchors.fill: parent
        drag.target: parent
        onDoubleClicked: {
            if (pressedButtons === Qt.LeftButton)
                dice.desk.openStreamItem(app)
                root.focus = false
        }
        propagateComposedEvents: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: {
            parent.forceActiveFocus()
            streamItemMoving = true
            root.zIndex = root.z
            root.z = 9999
            deskData.currentFocusedStreamItem = root

            if (pressedButtons === Qt.RightButton) {
                rightClickMenu.streamItemMenu.__xOffset = 5
                rightClickMenu.streamItemMenu.__yOffset = 10
                rightClickMenu.streamItemMenu.popup()
            }
        }
        onReleased: {
            streamItemMoving = false
            root.z = root.zIndex
        }
    }

    Keys.onReturnPressed: {
        if (root.activeFocus && !instanceLabelInput.visible)
            dice.desk.openStreamItem(app)
    }


    // Shadow Animations
    PropertyAnimation {
        id: anim1
        target: root
        property: "zDepth"
        running: streamItem_mouseArea.pressed && root.objectName !== "dummyStreamItem"
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
        running: !streamItem_mouseArea.pressed && root.objectName !== "dummyStreamItem"
        from: root.zDepth
        to: 1
        duration: 100
        easing.type: Easing.InOutQuad
        alwaysRunToEnd: true
    }

    Rectangle {
        id: _inputDock
        width: 15
        height: 15
        anchors.verticalCenter: root.verticalCenter
        anchors.left: root.left
        anchors.leftMargin: -width/2
        color: "#f4f4f4"
        radius: width/2
        border.width: 1
        border.color: colors.borderColor
    }

    Rectangle {
        id: _outputDock
        width: 15
        height: 15
        anchors.verticalCenter: root.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: -width/2
        color: "#f4f4f4"
        radius: width/2
        border.width: 1
        border.color: colors.borderColor
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
            drag.target: parent
            onPressed: {
                deskData.currentFocusedStreamItem = undefined
                desk.workSpace.startCreatingConnection(root)
                deskData.currentFocusedStreamItem = root
            }
        }
    }
}
