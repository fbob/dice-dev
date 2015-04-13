import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        Subheader { text: "Mesh Quality Controls" }

        FoamValue {
            label: "Maximum non-orthogonality allowed [°]"
            path: "system/meshQualityDict maxNonOrtho"
            dataType: "int"
        }
        FoamValue {
            label: "Max Internal Skewness allowed [°]"
            path: "system/meshQualityDict maxInternalSkewness"
            dataType: "int"
        }
        FoamValue {
            label: "Max Concaveness allowed [°]"
            path: "system/meshQualityDict maxConcave"
            dataType: "int"
        }
        FoamValue {
            label: "Minimum pyramid volume"
            path: "system/meshQualityDict minVol"
        }
        FoamValue {
            label: "Minimum quality of the tet"
            path: "system/meshQualityDict minTetQuality"
        }
        FoamValue {
            label: "minArea"
            path: "system/meshQualityDict minArea"
        }
        FoamValue {
            label: "minTwist"
            path: "system/meshQualityDict minTwist"
        }
        FoamValue {
            label: "Minimum normalised cell determinant"
            path: "system/meshQualityDict minDeterminant"
        }
        FoamValue {
            label: "minFaceWeight"
            path: "system/meshQualityDict minFaceWeight"
        }
        FoamValue {
            label: "minVolRatio"
            path: "system/meshQualityDict minVolRatio"
        }
        FoamValue {
            label: "minTriangleTwist"
            path: "system/meshQualityDict minTriangleTwist"
        }
    }
}
