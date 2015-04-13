import QtQuick 2.4

/*
 * Connects QML with Python through get/set methods.
 * The value is only loaded when the enabled property is true.
 */
QtObject {
    id: root

    property string methodName: ""
    property string getMethod: "get_" + methodName
    property string setMethod: "set_" + methodName
    property string changeSignalMethod: methodName + "_signal_name"

    property bool validMethodName: methodName != ""
    property bool validGetMethod: getMethod != "get_" && getMethod != ""
    property bool validSetMethod: setMethod != "set_" && setMethod != ""
    property bool validChangeSignalMethod: changeSignalMethod != "_signal_name" && changeSignalMethod != ""

    property string invalidString: "$invalid$"

    property var callParameter

    property bool enabled: false

    property var value
    property var __oldValue: null  // stored the old value to prevent setting a value twice
    property bool __settingReceivedValue: false  // true while setting a received value to prevent calling the python set method

    function extraPar(params, ep) {
        if (ep === undefined) ep = callParameter
        // adds extraParameter as the first element to params if awailable and returns params
        if (ep) {
            params.unshift(ep)
            return params
        } else {
            return params
        }
    }

    onValueChanged: {
        if (value !== __oldValue && !focus)
            root.load()
    }

    onCallParameterChanged: {
        timer.start() // bad hack; we cannot update the value as it might be disabled in the next moment
    }

    property var timer: Timer {
        repeat: false
        running: false
        interval: 10
        onTriggered: load()
    }

    function __setReceivedValue(newValue) {
        __settingReceivedValue = true
        __oldValue = value
        if (newValue === invalidString)
            value = ""
        else
            value = newValue
        __settingReceivedValue = false
    }

    function sameArray(first, second) {
        if (first.length !== second.length)
            return false;

        for (var i = 0, l=first.length; i < l; i++) {
            if (first[i] !== second[i]) {
                return false;
            }
        }
        return true;
    }

    function load(path){
        if (root.focus) return

        if (!validGetMethod || !enabled) return

        if (!!callParameter)
            var callPath = callParameter.split(" ").slice(1) // get the "var_path"
        else
            callPath = ""

        if (path === undefined || sameArray(callPath, path)) {
            app.call(getMethod, extraPar([]), function(returnValue) {
                __setReceivedValue(returnValue)
            })
        }
    }

    Component.onCompleted: {
        if (!validGetMethod) return
        root.load()
        if (validChangeSignalMethod)
            app.call(changeSignalMethod, extraPar([]), function(returnValue){app.setCallback(returnValue, root.load)})
    }

    onEnabledChanged: {
        if (enabled) {
            load()
        }
    }

    function setValue(newValue, dataType) {
        if (!enabled || !validSetMethod || __settingReceivedValue) return
        if (dataType === undefined) dataType = ""

        if (newValue === "" || ((dataType === "double" || dataType === "int") && isNaN(newValue))) {
            app.call(setMethod, extraPar([invalidString]))
            value = ""
            __oldValue = newValue
            return
        }

        // call setMethod only if the value is not what we just received from getMethod
        if (validSetMethod && newValue !== __oldValue) {
            print("NEW " + newValue + " "+dataType)
            app.call(setMethod, extraPar([newValue]), function(){})
            root.value = ""+newValue
        }

        __oldValue = newValue
    }
}
