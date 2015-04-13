import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        Subheader { text: "Material Point Coordinates" }
        FoamVector {
            path: "system/snappyHexMeshDict castellatedMeshControls locationInMesh"
        }
    }
}
