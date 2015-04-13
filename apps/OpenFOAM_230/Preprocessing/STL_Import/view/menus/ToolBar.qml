import DICE.App 1.0

ToolBarMenu {
    ToolBarGroup {
        title: "Utilities"
        flowLeftToRight: false

        SmallToolBarButton {
            action: actions.surfaceCheck
        }
        SmallToolBarButton {
            action: actions.surfaceOrient
        }
        SmallToolBarButton {
            action: actions.surfaceTransformPoints
        }
        SmallToolBarButton {
            action: actions.surfaceAutoPatch
        }
        SmallToolBarButton {
            action: actions.surfaceMeshInfo
        }
        SmallToolBarButton {
            action: actions.surfaceSplitByPatch
        }
        SmallToolBarButton {
            action: actions.surfaceRefineRedGreen
        }
        SmallToolBarButton {
            action: actions.surfaceCoarsen
        }
    }
    ToolBarGroup {
        title: "External Tools"
        BigToolBarButton {
            action: actions.openParaview
        }
    }
    ToolBarGroup {
        title: "History"
        ToggleButton {
            width: 150
            label: "Record history"
            methodName: "app_config"
            callParameter: "recordHistory"
        }
    }
}
