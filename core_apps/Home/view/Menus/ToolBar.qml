import DICE.Components 1.0

ToolBarMenu {
    ToolBarGroup {
        title: "Project"

        BigToolBarButton {
            action: actions.createNewProjectAction
        }
        BigToolBarButton {
            action: actions.loadProjectAction
        }
        BigToolBarButton {
            action: actions.closeProject
            visible: enabled
        }
    }
    ToolBarGroup {
        title: "Settings"

        BigToolBarButton {
            action: actions.openDiceSettingsAction
        }
    }
    ToolBarGroup {
        title: "Help"

        BigToolBarButton {
            action: actions.openHelpAction
        }
    }
}
