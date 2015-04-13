import QtQuick 2.4

import DICE.Components 1.0

ListView {
    id: navi

    height: childrenRect.height
    delegate: NaviListitemDelegate {}
    interactive: false
    model: ListModel {}
    header: Rectangle {
        height: 1
        width: parent.width
        color: colors.borderColor
    }
    footer: Rectangle {
        height: 1
        width: parent.width
        color: colors.borderColor
        BottomShadow {}
    }

    section.property: "sectionClass"
    section.criteria: ViewSection.FullString
    section.delegate: SectionDevider {}
}
