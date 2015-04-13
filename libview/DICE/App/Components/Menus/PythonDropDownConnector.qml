import QtQuick 2.4

import DICE.App 1.0

PythonValueConnector {
    id: root
    property string modelPath

    property string modelMethodName: "model_data"
    property string getModelMethod: "get_" + modelMethodName
    property string changeSignalModelMethod: modelMethodName + "_signal_name"

    property bool validModelMethodName: modelMethodName != ""
    property bool validGetModelMethod: getMethod != "get_" && getModelMethod != ""
    property bool validChangeSignalModelMethod: changeSignalModelMethod != "_signal_name" && changeSignalModelMethod != ""

    property ListModel model: ListModel{}
    property int currentIndex: 0
    property string textRole: "text"
    property bool loadingModel: false
    property bool __internalChange: false

    onModelPathChanged: {
        loadModel()
    }

    function loadModel() {
        if (!validGetModelMethod) return
//        loadingModel = true  // seems to work without disabling the connector, but not sure why
        app.call(getModelMethod, extraPar([], modelPath), function(returnValue) {
            model.clear()
            for (var i=0; i<returnValue.length; i++) {
                var data = {}
                data[textRole] = returnValue[i]
                model.append(data)
            }
            loadingModel = false
            // no need to load here, as unsetting loadingModel should trigger an enabledChanged signal which will start load()
        })
    }

    Component.onCompleted: {
        if (model.count === 0) {
            if (!validGetModelMethod) return
            root.loadModel()
            if (validChangeSignalModelMethod)
                app.call(changeSignalModelMethod, extraPar([], modelPath), function(returnValue) {app.setCallback(returnValue, root.loadModel)})
        }
    }

    // emitted by PythonValueConnector's value changed in the load() method
    onValueChanged: {
        for (var i=0; i< model.count; i++) {
            if (model.get(i)[textRole] === value) {
                if (currentIndex !== i) {
                    __internalChange = true
                    currentIndex = i
                    __internalChange = false
                }
                return
            }
        }
    }

    // emitted by the ComboBox or similar components
    onCurrentIndexChanged: {
        if (__internalChange) return
        var text = model.get(currentIndex)[textRole]
        setValue(text)
    }

}
