import QtQuick 2.4
import QtQuick.Controls 1.3
import DICE.App 1.0

Body {

    RaisedButton {
        text: "run"
        onClicked: {
            app.call("run")
        }
    }

    TextArea {
        id: textArea
        width: parent.width
        height: 500
        property bool loaded: false
        onTextChanged: if (loaded) app.call("set_code", [text])
        Component.onCompleted: {
            app.call("get_code", [], function(code) {textArea.text = code; textArea.loaded = true;})
        }
    }
}
