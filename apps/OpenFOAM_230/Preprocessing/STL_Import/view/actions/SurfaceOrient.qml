import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

Component {
    Body {
        width: 300

        Card {
            Subheader { text: "SurfaceOrient - Utility" }
            BodyText {
                text: "Set normal consistent with respect to a user provided ’outside’ point. If the -inside is used the point is considered inside. (src: http://www.openfoam.org/docs/user/standard-utilities.php)"
            }
            expanded: false
        }
        Card {
            Subheader { text: "Point Coordinates" }
            VectorField {
                id: pointCoordinates
                methodName: "surface_orient_point"
            }
        }
        Card {
            Subheader { text: "Options" }
            DropDown {
                id: optionsList
                model: ListModel {
                    ListElement {
                        text: "None"
                        option: ""
                    }
                    ListElement {
                        text: "Inside"
                        option: "-inside"
                    }
                    ListElement {
                        text: "Use Pierce Test"
                        option: "-usePierceTest"
                    }
                }
                textRole: "text"
            }
        }
        Card {
            FlatButton {
                text: "Run surfaceOrient"
                property string selectedOption: optionsList.model.get(optionsList.currentIndex).option
                onClicked: {
                    app.call("surface_orient", [treeView.currentNodePath[0], selectedOption])
                    leftOptionsSideBar.close()
                }
            }
        }
    }
}
