import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Card {
    title: "Mandatory Settings"

    visibleShadowAndBorder: false
    expanderVisible: false

    FoamValue {
        label: "maxCellSize [m]"
        path: "system/meshDict maxCellSize"
    }
}
