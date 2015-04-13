import QtQuick 2.4
import QtQuick.Layouts 1.1

import DICE.App 1.0

GridLayout {
    id: root

    property string dataType: "double"
    property var doubleValidator: DoubleValidator{}
    property var intValidator: IntValidator{}

    property string callParameter
    property string methodName

    width: parent.width
    opacity: enabled ? 1 : 0.5

    Repeater {
        model: rows
        Repeater {
            model: columns

            property int row: index

            ValueField {
                property int column: index

                label: "("+row+", "+column+")"

                methodName: root.methodName
                callParameter: root.callParameter+ " "+row+" "+column
                dataType: root.dataType
                doubleValidator: root.doubleValidator
                intValidator: root.intValidator
            }
        }
    }
}
