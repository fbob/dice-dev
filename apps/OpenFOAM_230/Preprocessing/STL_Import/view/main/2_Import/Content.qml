import QtQuick 2.4

import DICE.App 1.0

Body {
    property alias treeView: treeView

    Card {
        Subheader { text: "Import files" }
        TreeView {
            id: treeView

            maxHeight: appHeight - 200
            width: parent.width
            model: FileModel {}
        }
        Item {
            height: 40
            width: parent.width
        }
        Row {
            spacing: 10
            width: parent.width
            RaisedButton {
                text: "Import"
                width: (parent.width - parent.spacing)/2
                onClicked: {
                    fileDialog.open("import_files", "Select Files for Import", ["Object-Files (*.stl *.obj)", "STL File (*.stl)", "OBJ File (*.obj)"], true)
                }
            }
            RaisedButton {
                text: "Delete selected file"
                color: colors.warningColor
                textColor: "#fff"
                width: (parent.width - parent.spacing)/2
                onClicked: {
                    app.call("remove_file_by_path", [treeView.currentNodePath])
                }
            }
        }
    }
}
