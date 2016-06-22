import QtQuick 2.0
import QtWebEngine 1.2
import QtQuick.Controls 1.4

import "readability.js" as Reader
//import QQRCode 1.0

WebEngineView {
    property alias weburl: web_view.url
    property alias zoomfactor: web_view.zoomFactor

    id: web_view
    visible: true
    objectName: "webview"
    anchors.fill: parent
    url: "qrc:/wellcome/resource/wellcome.html"
    zoomFactor: 1
    onLoadProgressChanged: {
        if (loadProgress > 79) {
            busyIndicator.running = false;
            //scheduleZoom();
        }
    }
    onLoadingChanged: {
        console.log("loading changed.....")
        busyIndicator.running = loading;
    }

    Component.onCompleted: {
        web_view.settings.pluginsEnabled = true;
        web_view.settings.javascriptCanOpenWindows = false;
        web_view.settings.spatialNavigationEnabled = false;
        zoomFactor: zoom_size.value


        var reader = new Reader.Readability();
        var url = "http://www.jianshu.com/p/e9054cb333e8"
        //reader.readabilityGet(url, onGetReadabilityData, onReadabilityGetErr)

    }

    BusyIndicator{
        id: busyIndicator
        z: 2
        running: true
        anchors.centerIn: parent

    }

    Rectangle {
        id: reader_mode
        width: 32; height: width
        radius: 16; visible: true;
        anchors.top: parent.top; anchors.topMargin: 10;
        anchors.right: parent.right; anchors.rightMargin: 120;
        //anchors.centerIn: parent
        color: "#f69331"; clip: true
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("reader mode fucked")
            }
        }
    }

    Slider {
        id: zoom_size
        height: 72
        z: 2
        maximumValue: 2.0
        minimumValue: 0.5
        orientation: Qt.Vertical
        anchors.right: parent.right
        anchors.rightMargin: 6
        anchors.top: parent.top
        anchors.topMargin: 32
        updateValueWhileDragging: true
        value: 1.0
        stepSize: 0.1
        onValueChanged: {
            web_view.zoomFactor = value
        }
    }
    Timer {
        id: timer
        interval: 1000; running: false; repeat: false;
        onTriggered: {
            web_view.runJavaScript("document.body.style.zoom="+zoom_size.value, function(result) { console.log(result); });
        }
    }
    function scheduleZoom() {
        if (timer.running == true) {
            timer.restart();
        } else {
            timer.start();
        }
    }

    function iswebview() {return true;}

    function loadUrl(url) {web_view.url = url;}

    function loadFromHtmlString(html, baseUrl) {web_view.loadHtml(html, baseUrl);}

    function onGetReadabilityData(res, data) {
        console.log("get get get get get ......")
        web_view.loadFromHtmlString(data.content, "https://segmentfault.com/a/1190000000602050")
    }

    function onReadabilityGetErr(res, status) {
        console.log("get get get get get failed......")
    }

}
