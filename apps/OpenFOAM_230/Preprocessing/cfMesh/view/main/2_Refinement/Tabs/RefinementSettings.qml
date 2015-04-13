import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Refinement Settings"
    
    visibleShadowAndBorder: false
    expanderVisible: false

    FoamValue {
        label: "boundaryCellSize [m]"
        optional: true
        path: "system/meshDict boundaryCellSize"
    }

    FoamValue {
        label: "boundaryCellSizeRefinementThickness [m]"
        optional: true
        path: "system/meshDict boundaryCellSizeRefinementThickness"
    }

    FoamValue {
        label: "minCellSize [m]"
        optional: true
        path: "system/meshDict minCellSize"
    }
}
