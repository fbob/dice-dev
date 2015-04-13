import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

Component {
    Body {
        width: 300

        Card {
            Subheader { text: "SurfaceAutoPatch - Utility" }
            BodyText {
                text: "Patches surface according to feature angle."
            }
            expanded: false
        }
        Card {
            Subheader { text: "Feature angle [°]" }
            ValueField {
                id: featureAngle
                label: ""
                methodName: "surface_auto_patch_angle"
            }
        }
        Card {
            FlatButton {
                text: "Run surfaceAutoPatch"
                onClicked: {
                    app.call("surface_auto_patch", [treeView.currentNodePath[0]])
                    leftOptionsSideBar.close()
                }
            }
        }
    }
}
