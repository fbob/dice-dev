import QtQuick 2.4

import DICE.App 1.0
import DICE.App.Foam 1.0

Body {
    Card {
        Subheader { text: "Mesh Information" }
        FlatButton {
            visible: app.status === "finished"
            text: "Run CheckMesh"
            onClicked: appRoot.actions.runCheckMesh.trigger()
        }
        BodyText {
            visible: app.status !== "finished"
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "No Results"
        }
        ValueField {
            callParameter: "points"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        ValueField {
            callParameter: "cells"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        ValueField {
            callParameter: "boundary_openness"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        ValueField {
            callParameter: "max_cell_openness"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        ValueField {
            callParameter: "max_aspect_openness"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        ValueField {
            callParameter: "non_orthogonality"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        ValueField {
            callParameter: "max_skewness"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        ValueField {
            id: mesh_check_failed

            callParameter: "mesh_checks_failed"
            label: callParameter
            readOnly: true
            getMethod: "get_mesh_info"
            changeSignalMethod: "mesh_info_signal_name"
        }
        BodyText {
            visible: parseInt(mesh_check_failed.text) > 0
            text: "Mesh check failed !!!"
            color: colors.warningColor
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
