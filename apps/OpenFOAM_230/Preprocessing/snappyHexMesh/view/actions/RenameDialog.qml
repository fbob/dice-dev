import QtQuick 2.4

import DICE.App 1.0

Component {

    Body {
        width: 300

        Card {
            id: root

            Subheader { text: "Rename Refinement Object" }

            InputField {
                id: oldName

                label: "Old Name"
                text: treeView.currentNode.model.text
                enabled: false
            }

            InputField {
                id: newNameInput

                label: "New Name"

                onEditingFinished: {
                    var newName = newNameInput.text
                    if (root.checkIfNameValid(newName) && root.activeFocus) {
                        renameButton.clicked()
                    }
                    else
                        selectAll()
                }
            }

            FlatButton {
                id: renameButton

                text: "Rename"
                onClicked: {
                    var newName = newNameInput.text
                    if (root.checkIfNameValid(newName)) {
                        app.call("rename_refinement_object", [treeView.currentNode.model.text, newName], function(returnValue){
                            newNameInput.showWarning = returnValue
                            if (!returnValue)
                                leftOptionsSideBar.close()
                        })
                    }
                }
            }

            function checkIfNameValid(name) {
                var regExp = /^[^\\/?%*:|"<>]+$/
                if (regExp.test(name)) {
                    newNameInput.showWarning = false
                    return true
                }
                else
                {
                    newNameInput.showWarning = true
                    return false
                }
            }
        }
    }
}

