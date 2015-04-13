import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2

Dialog {
    id: customDialog

    property Component content
    Loader {
        id: contentLoader

        sourceComponent: content
        visible: false
    }

    modality: Qt.WindowModal
    title: "Customized content"
//    onRejected: lastChosen.text = "Rejected"
//    onAccepted: lastChosen.text = "Accepted " +
//                (clickedButton === StandardButton.Retry ? "(Retry)" : "(OK)")
//    onButtonClicked: if (clickedButton === StandardButton.Retry) lastChosen.text = "Retry"
//    contentItem: Rectangle {
//        color: "lightskyblue"
//        implicitWidth: 400
//        implicitHeight: 100
//        Label {
//            text: "Hello blue sky!"
//            color: "navy"
//            anchors.centerIn: parent
//        }
//        Keys.onPressed: if (event.key === Qt.Key_R && (event.modifiers & Qt.ControlModifier)) filledDialog.click(StandardButton.Retry)
//        Keys.onEnterPressed: filledDialog.accept()
//        Keys.onEscapePressed: filledDialog.reject()
//        Keys.onBackPressed: filledDialog.reject() // especially necessary on Android
//    }
    contentItem: contentLoader.item
//      standardButtons: StandardButton.Yes
//    onHelp: lastChosen.text = "Yelped for help!"
//    onYes: StandardButton.Yes
//    Keys.onEnterPressed: customDialog.accept()
//    Keys.onEscapePressed: customDialog.reject()
}
