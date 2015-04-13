import QtQuick 2.4

Item {
    id: root

    property bool exists
    property string path

    function createDict(defaultValue) {
        if (defaultValue === undefined) defaultValue = {}
        app.call("create_dict_in_path", [path, defaultValue], function(returnValue) {checkIfDictExists()})
    }

    function removeDict() {
        app.call("remove_from_dict", [path], function(returnValue) {checkIfDictExists()})
    }

    function checkIfDictExists() {
        app.call("foam_dict_exists", [path], function(returnValue) {exists = returnValue} )
    }

    onPathChanged: {
        if (path !== undefined) {
            checkIfDictExists()
        }
    }
}
