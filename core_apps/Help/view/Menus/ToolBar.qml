import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import DICE.Components 1.0

ToolBarMenu {
    ToolBarGroup {
        title: "Controls"

        BigToolBarButton {
            action: actions.goHomeAction
        }
        BigToolBarButton {
            action: actions.goBackAction
        }
        BigToolBarButton {
            action: actions.goForwardAction
        }
        BigToolBarButton {
            action: actions.reloadAction
        }
    }
    ToolBarGroup {
        title: "Adress Bar"

        Rectangle {
            width: 500
            height: 50
            TextField {
                id: adressBar

                width: parent.width
                height: parent.height - progressBar.height
                anchors.verticalCenter: parent.verticalCenter
                style: TextFieldStyle {
                    padding {
                        left: 26
                    }
                }
                text: webEngineView && webEngineView.url
                onAccepted: webEngineView.url = text
            }
            ProgressBar {
                id: progressBar

                height: 3
                anchors {
                    left: parent.left
                    top: parent.bottom
                    right: parent.right
                }
                style: ProgressBarStyle {
                    background: Item {}
                }
                z: -2;
                minimumValue: 0
                maximumValue: 100
                value: (webEngineView && webEngineView.loadProgress < 100) ? webEngineView.loadProgress : 0
            }
        }
    }
}
