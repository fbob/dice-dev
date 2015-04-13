import QtQuick 2.4
import QtQuick.Controls 1.3

Image {
    id: root

    property string getPlot: ""
    property string plotSignal: ""

    // use an empty svg by default
    property string rawData: '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <svg
           xmlns:dc="http://purl.org/dc/elements/1.1/"
           xmlns:cc="http://creativecommons.org/ns#"
           xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
           xmlns:svg="http://www.w3.org/2000/svg"
           xmlns="http://www.w3.org/2000/svg"
           version="1.1"
           width="1mm"
           height="1mm"
           id="svg2">
          <defs
             id="defs4" />
          <metadata
             id="metadata7">
            <rdf:RDF>
              <cc:Work
                 rdf:about="">
                <dc:format>image/svg+xml</dc:format>
                <dc:type
                   rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
                <dc:title></dc:title>
              </cc:Work>
            </rdf:RDF>
          </metadata>
          <g
             id="layer1" />
        </svg>'

    source: "data:image/svg," + rawData
//    sourceSize.width: width
//    sourceSize.height:height
    width: root.width
    height: root.height

    BusyIndicator {
        id: busy

        running: false
        width: parent.width
        height: parent.height
    }

    function replot() {
        if (getPlot != "") {
            busy.running = true
            app.call(getPlot, [], function(result) {
                if (result) {
                    root.rawData = result
                    busy.running = false
                }
            })
        }
    }

    Component.onCompleted: {
        if (plotSignal != "") {
            app.setCallback(plotSignal, root.replot)
        }
    }

    Timer {
        id: timer

        interval: 1
        repeat: false
        running: true
        onTriggered: {
            root.replot()
        }
    }
}
