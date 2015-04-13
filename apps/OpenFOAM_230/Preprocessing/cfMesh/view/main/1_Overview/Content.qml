import DICE.App 1.0

Body {
    Card {
        header: CenteredImage {
            height: 100
            color: "#5275a6"
            source: "images/cfMesh.svg"
        }
        Subheader { text: "Description" }
        BodyText {
            text: "cfMesh is a cross-platform library for automatic mesh generation that is built on top of OpenFOAM. It is licensed under GPL and compatible with all recent versions of OpenFOAM and foam-extend."
        }
    }
    
    Card {
        Title { text: "Quirks" }
        BodyText {
            text: "This app will only get the first file of the input app."
        }
    }

    Card {
        Subheader { text: "Example" }
        FullWidthImage {
            source: "images/motorbike_sHM.png"
        }
        BodyText {
            text: qsTr("Mesh from Motorbike-Tutorial:")
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
