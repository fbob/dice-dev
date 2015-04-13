import QtQuick 2.4
import QtQuick.Controls 1.3

QtObject {
    property alias streamItemMenu: streamItemMenu
    property alias connectorMenu: connectorMenu

    property list<Menu> menus: [
        Menu {
            id: streamItemMenu
            title: "StreamItem"

            MenuItem {
                action: actions.runSelectedStreamItem
            }
            MenuItem {
                action: actions.killCurrentRunningSelectedStreamItem
                visible: action.enabled
            }

            MenuSeparator { }
            MenuItem {
                action: actions.createConnectorAction
            }
            MenuSeparator { }
            MenuItem {
                action: actions.renameStreamItemAction
            }
            MenuItem {
                action: actions.deleteStreamItemFromWorkSpaceAction
            }
            MenuItem {
                action: actions.cloneSelectedStreamItem
            }
        },

        Menu {
            id: connectorMenu
            title: "Connector"

            MenuItem {
                action: actions.deleteConnectorAction
            }
        }
    ]
}

