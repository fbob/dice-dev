import DICE.App 1.0

DropDown {
    id: root

    property alias path: root.callParameter
    property string helpPath: "foam/"+path

    methodName: "foam_var"
    changeSignalMethod: ""

    onActiveFocusChanged: {
        if (activeFocus) {
            appWindow.helpPath = root.helpPath
        }
    }
}
