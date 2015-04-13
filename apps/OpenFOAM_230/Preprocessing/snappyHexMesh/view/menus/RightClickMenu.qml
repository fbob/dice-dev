import QtQuick 2.4
import QtQuick.Controls 1.3

QtObject {
    property alias treeViewMenu: treeViewMenu

    property list<Menu> menus: [
        Menu {
            id: treeViewMenu
            title: "TreeViewMenu"

            MenuItem {
                visible: enabled
                action: actions.renameRefinementObject
            }

            MenuItem {
                visible: enabled
                action: actions.removeRefinementObject
            }
        }
    ]
}

