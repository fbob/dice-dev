import QtQuick 2.4
import QtQuick.Controls 1.3

import DICE.Components.Styles 1.0

ScrollView {
    id: root
    property bool activeScrolling: true
    property bool vbarVisible: __verticalScrollBar.visible
    property int contentWidth: vbarVisible? width - __verticalScrollBar.width : width

    style: ScrollViewStyle_DICE {}
}
