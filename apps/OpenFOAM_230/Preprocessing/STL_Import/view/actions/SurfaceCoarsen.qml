import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

Component {
    Body {
        width: 300

        Card {
            Subheader { text: "SurfaceCoarsen - Utility" }
            BodyText {
                text: "Surface coarsening using ’bunnylod’."
            }
            expanded: false
        }
        Card {
            Subheader { text: "Reduction Factor" }
            ValueField {
                id: reductionFactor
                label: ""
                methodName: "surface_coarsen_reduction_factor"
            }
        }
        Card {
            FlatButton {
                text: "Run surfaceCoarsen"
                onClicked: {
                    app.call("surface_coarsen", [treeView.currentNodePath[0]])
                    leftOptionsSideBar.close()
                }
            }
        }
    }
}
