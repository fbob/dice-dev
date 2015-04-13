import DICE.App 1.0

Body {
    Card {
        header: CenteredImage {
            color: "#f2f2f2"
            source: "images/stl_obj_import_icon.svg"
            height: 100
        }
        Title { text: "STL Import" }
        Subheader { text: "Description" }
        BodyText {
            text: qsTr("Imports and manipulates STL-Files for further processing. Every action is recorded in the history so by pushing the Play-Button every step of the manipulation can be performed again.")
        }
    }
    Card {
        Subheader { text: "Example" }
        BodyText {
            text: qsTr("An Motorbike.stl is imported, checked, resized and send to snappyHexMesh for the meshing process.")
        }
    }
    Card {
        Subheader { text: "Input" }
        List {
            maxHeight: 300
            width: parent.width
            modelData: app.input_types_model
            delegate: ListItem {
                text: input_type
            }
        }
    }
    Card {
        Subheader { text: "Output" }
        List {
            maxHeight: 300
            width: parent.width
            modelData: app.output_types_model
            delegate: ListItem {
                text: output_type
            }
        }
    }
}
