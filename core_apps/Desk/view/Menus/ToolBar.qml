import DICE.Components 1.0

ToolBarMenu {
    ToolBarGroup {
        title: "App Controls"
        DeskMainControls {}
    }

    ToolBarGroup {
        title: "Connections"

        BigToolBarButton {
            action: actions.createConnectorAction
        }
        BigToolBarButton {
            action: actions.deleteConnectorAction
        }
    }

    ToolBarGroup {
        title: "Stream Items"

        BigToolBarButton {
            action: actions.deleteStreamItemFromWorkSpaceAction
        }
        BigToolBarButton {
            action: actions.renameStreamItemAction
        }
    }
}
