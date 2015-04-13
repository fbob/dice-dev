import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.Theme 1.0
import DICE.App 1.0

Card {
    id: root

    property alias currentIndex: tabs.currentIndex
    property alias model: tabs.model

    contentMargin: 0
    contentTopMargin: 20
    contentBottomMargin: 0

    Row {
        width: parent.width
        height: 50
        anchors {
            left: parent.left
            right: parent.right
        }

        clip: true

        FlatButton {
            width: 50
            height: parent.height
            iconSource: "images/leftanglearrow.svg"
            onClicked: tabs.decrementCurrentIndex()
            opacity: tabs.currentIndex !== 0 ? 1 : 0
            enabled: tabs.currentIndex !== 0
            color: "#fff"
        }

        ListView {
            id: tabs

            width: parent.width - 100
            height: parent.height
            orientation: Qt.LeftToRight
            interactive: false
            clip: true
            cacheBuffer: 2000
            highlightMoveVelocity: 1000
            model: ListModel {}
            delegate: Item {
                width: ListView.view.width
                height: header.height

                Subheader {
                    id: header

                    text: title
                    visible: false
                }

                ComboBox {
                    id: comboBox

                    width: parent.width
                    height: parent.height
                    model: tabs.model
                    currentIndex: index
                    onCurrentIndexChanged: {
                        if (currentIndex !== index) {
                            tabs.currentIndex = currentIndex
                            currentIndex = index
                        }
                    }
                    enabled: model.count > 1

                    style: ComboBoxStyle {
                        background: Item {
                            implicitWidth: Math.round(control.height * 4.5)
                            implicitHeight: Math.max(25, Math.round(control.height * 1.2))

                            FontAwesomeIcon {
                                name: "Sort"
                                color: control.hovered || control.activeFocus ? colors.highlightColor : "#666"
                                size: 10
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: 4
                                anchors.left: parent.left
                                anchors.leftMargin: 25
                                opacity: control.enabled ? 0.6 : 0.3
                                visible: control.count > 1
                            }

                            FontAwesomeIcon {
                                name: "Sort"
                                color: control.hovered || control.activeFocus ? colors.highlightColor : "#666"
                                size: 10
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: 4
                                anchors.right: parent.right
                                anchors.rightMargin: 25
                                opacity: control.enabled ? 0.6 : 0.3
                                visible: control.count > 1
                            }
                        }
                        label: Item {
                            Subheader {
                                text: control.currentText
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }
                        }
                    }
                }
            }
        }

        FlatButton {
            width: 50
            height: parent.height
            iconSource: "images/rightanglearrow.svg"
            onClicked: tabs.incrementCurrentIndex()
            opacity: tabs.currentIndex !== tabs.count-1 ? 1 : 0
            enabled: tabs.currentIndex !== tabs.count-1
            color: "#fff"
        }
    }

    onCurrentIndexChanged: {
        // i=1 because starts after Row-Element
        for (var i=1; i<root.children.length; i++) {
            if (currentIndex+1 === i)
                root.children[i].visible = true
            else
                root.children[i].visible = false
        }
    }

    onChildrenChanged: {
        model.clear()
        for (var i=1; i<root.children.length; i++) {
            model.append({"title" : root.children[i].title})
        }
    }
}
