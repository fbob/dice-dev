import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    property alias treeView: treeView

    Card {
        Subheader { text: "Geometry objects" }
        TreeView {
            id: treeView

            maxHeight: 300
            width: parent.width
            modelData: app.treeViewModel
            onCurrentNodeChanged: {
                visItem.pickedPatch = currentNode.text
            }
            property Connections visConnection: Connections {
                target: visItem
                onPickedPatchChanged: {
                    if (treeView.currentNode.text !== visItem.pickedPatch)
                        treeView.setCurrentNode(visItem.pickedPatch)
                }
            }
        }
    }
}
