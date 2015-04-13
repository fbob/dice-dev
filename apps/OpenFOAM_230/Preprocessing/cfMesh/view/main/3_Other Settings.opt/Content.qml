import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        FoamValue {
            label: "enforceGeometryConstraints"
            optional: true
            path: "system/meshDict enforceGeometryConstraints"
        }
    }
}
