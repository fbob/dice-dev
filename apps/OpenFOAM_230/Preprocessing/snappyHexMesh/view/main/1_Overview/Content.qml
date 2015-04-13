import QtQuick 2.4
import DICE.App 1.0

Body {
    Card {
        header: CenteredImage {
            height: 100
            color: "#D64F2F"
            source: "images/sHM_icon.png"
        }
        Subheader { text: "Description" }
        BodyText {
            text: qsTr("The snappyHexMesh utility generates 3-dimensional meshes containing hexahedra (hex) and split-hexahedra (split-hex) automatically from triangulated surface geometries in Stereolithography (STL) format. The mesh approximately conforms to the surface by iteratively refining a starting mesh and morphing the resulting split-hex mesh to the surface. An optional phase will shrink back the resulting mesh and insert cell layers. The specification of mesh refinement level is very flexible and the surface handling is robust with a pre-specified final mesh quality. It runs in parallel with a load balancing step every iteration. <br><br>(src: OpenFOAMWiki)")
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
