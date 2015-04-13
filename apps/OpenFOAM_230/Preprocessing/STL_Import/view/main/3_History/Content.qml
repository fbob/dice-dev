import QtQuick 2.4

import DICE.App 1.0

Card {
    Subheader { text: "History of Actions" }
    FlatButton {
        text: "clear history"
        onClicked: app.call("clear_history")
    }
    Row {
        spacing: 10
        width: parent.width
        RaisedButton {
            text: "Remove Last Action and Repeat All"
            iconSource: "images/removeLastAction.svg"
            width: (parent.width - parent.spacing)/2
            onClicked: app.call("remove_last_history_entry")
        }
        RaisedButton {
            text: "Replay History"
            color: colors.highlightColor
            textColor: "#fff"
            iconSource: "images/replayHistory.svg"
            width: (parent.width - parent.spacing)/2
            onClicked: {
                app.call("repeat_history")
            }
        }
    }
    Item {
        height: 40
        width: parent.width
    }
    ListView {
        id: lview
        width: parent.width
        height: childrenRect.height
        model: HistoryModel {}
        delegate: historyItemDelegate
    }
    property Component historyItemDelegate: Rectangle {
        width: parent.width
        height: childrenRect.height + 20
        color: index % 2 ? "#f4f4f4" : "transparent"
        BodyText { text: cmd + " " + parameterStr }
    }
    Item {
        height: 40
        width: parent.width
    }
    RaisedButton {
        text: "Remove Last Action and Replay History"
        iconSource: "images/removeLastAction.svg"
        onClicked: app.call("remove_last_history_entry")
        maximumLineCount: 2
    }
}
