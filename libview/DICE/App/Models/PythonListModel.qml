import QtQuick 2.4

ListModel {
    id: root

    property string propertyName: ""
    property var modelData: !!app && propertyName !== "" ? app[propertyName] : undefined

    property bool _loaded: false
    property bool _ccSet: false
    property string loadMethod
    property string changedCallback
    property string removeLastMethod
    property string removeIndexMethod
    property var loadParameters: []

    onModelDataChanged: {
        if (modelData !== undefined) {
            root.clear()
            root.append(modelData)
        }
    }

    onLoadParametersChanged: reload()

    Component.onCompleted: {
        if (loadParameters !== undefined)
            loadModel()
    }

    function loadModel() {
        if (_loaded || !app) return

        if (loadMethod) {
            app.call(loadMethod, loadParameters, function(data) {
                root.clear()
                root.append(data)
                root._loaded = true
            })
        }
        if (!_ccSet && changedCallback) {
            app.setCallback(changedCallback, reload)
            _ccSet = true
        }
    }

    function removeLast() {
        // TODO: deprecated, update the model via python
        if (removeLastMethod) {
            app.call(removeLastMethod)
        }
    }

    function reload() {
        _loaded = false
        loadModel()
    }

    function removeIndex(index) {
        // TODO: deprecated, update the model via python
        if (removeIndexMethod) {
            app.call(removeIndexMethod, [index])
        }
    }
}
