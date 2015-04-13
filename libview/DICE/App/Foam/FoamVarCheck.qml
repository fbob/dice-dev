import QtQuick 2.4

Item {
    id: root

    property bool foamVarExists
    property string path
    property string value

    function createFoamVar() {
        app.call("create_foam_var", [path, value], function(returnValue) {checkIfFoamVarExists()})
    }

    function removeFoamVar() {
        app.call("remove_from_dict", [path], function(returnValue) {checkIfFoamVarExists()})
    }

    function checkIfFoamVarExists() {
        app.call("foam_var_exists", [path], function(returnValue) {foamVarExists = returnValue} )
    }

    onPathChanged: {
        if (path !== undefined) {
            checkIfFoamVarExists()
        }
    }
}
