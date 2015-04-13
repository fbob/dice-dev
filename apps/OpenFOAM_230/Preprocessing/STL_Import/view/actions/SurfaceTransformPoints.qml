import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0

Component {
    Body {
        width: 300

        Card {
            Subheader { text: "SurfaceTransformPoints - Utility" }
            BodyText {
                text: "Transform a surface."
            }
            expanded: false
        }
        Card {
            Subheader { text: "Options" }
            DropDown {
                id: optionsList
                model: ListModel {
                    ListElement {
                        text: "Roll Pitch Yaw"
                        option: "-rollPitchYaw"
                    }
                    ListElement {
                        text: "Rotate"
                        option: "-rotate"
                    }
                    ListElement {
                        text: "Scale"
                        option: "-scale"
                    }
                    ListElement {
                        text: "Translate"
                        option: "-translate"
                    }
                    ListElement {
                        text: "Yaw Pitch Roll"
                        option: "-yawPitchRoll"
                    }
                }
            }
        }
        Card {
            visible: optionsList.currentText === "Roll Pitch Yaw"
            VectorField {
                xLabel: "Roll [°]"
                yLabel: "Pitch [°]"
                zLabel: "Yaw [°]"
                methodName: "surface_transform_points_vector"
            }
        }
        Card {
            visible: optionsList.currentText === "Rotate"
            VectorField {
                xLabel: "X"
                yLabel: "Y"
                zLabel: "Z"
                methodName: "surface_transform_points_vector"
            }
            VectorField {
                xLabel: "X"
                yLabel: "Y"
                zLabel: "Z"
                methodName: "surface_transform_points_vector_2"
            }
            BodyText {
                text: "Transform in terms of a rotation between <vectorA> and <vectorB> - eg, '( (1 0 0) (0 0 1) )'"
            }
        }
        Card {
            visible: optionsList.currentText === "Scale"
            VectorField {
                xLabel: "Scale in X"
                yLabel: "Scale in Y"
                zLabel: "Scale in Z"
                methodName: "surface_transform_points_vector"
            }
        }
        Card {
            visible: optionsList.currentText === "Translate"
            VectorField {
                xLabel: "Translate in X"
                yLabel: "Translate in Y"
                zLabel: "Translate in Z"
                methodName: "surface_transform_points_vector"
            }
        }
        Card {
            visible: optionsList.currentText === "Yaw Pitch Roll"
            VectorField {
                xLabel: "Yaw [°]"
                yLabel: "Pitch [°]"
                zLabel: "Roll [°]"
                methodName: "surface_transform_points_vector"
            }
        }

        Card {
            FlatButton {
                text: "Run surfaceTransformPoints"
                property string selectedOption: optionsList.model.get(optionsList.currentIndex).option
                onClicked: {
                    app.call("surface_transform_points", [treeView.currentNodePath[0], selectedOption])
                    leftOptionsSideBar.close()
                }
            }
        }
    }
}
