import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.App 1.0
import DICE.App.Foam 1.0

Component {

    Body {
        width: 300

        Card {
            id: root

            Subheader { text: "Generate Surface Box" }

            VectorField {
                id: negVec

                xLabel: "x-neg"
                yLabel: "y-neg"
                zLabel: "z-neg"
            }

            VectorField {
                id: posVec

                xLabel: "x-pos"
                yLabel: "y-pos"
                zLabel: "z-pos"
            }

            InputField{
                id: output_name

                label: "Output name"
            }

            FlatButton {
                text: "Generate"
                onClicked: {
                    app.call("generate_surface_box", [treeView.currentNodePath[0],
                                                      output_name.text,
                                                      negVec.xText, posVec.xText,
                                                      negVec.yText, posVec.yText,
                                                      negVec.zText, posVec.zText])
                }
            }
        }
    }
}
