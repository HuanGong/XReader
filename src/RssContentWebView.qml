import QtQuick 2.0
import QtWebEngine 1.2
import QtQuick.Controls 1.4


WebEngineView {
    property alias weburl: web_view.url
    property alias zoomfactor: web_view.zoomFactor

    id: web_view
    objectName: "webview"
    anchors.fill: parent
    url: "qrc:/wellcome/resource/wellcome.html"
    zoomFactor: 1
    onLoadProgressChanged: {
        if (loadProgress > 79) {
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
    }

    BusyIndicator{
        id: busyIndicator
        z: 2
        running: true
        anchors.centerIn: parent

    }

    Slider {
        id: zoom_size
        z: 2
        orientation: Qt.Vertical
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        maximumValue: 2.0
        minimumValue: 0.5
        updateValueWhileDragging: true
        value: 0.8
        stepSize: 0.1
        height: 100
        onValueChanged: {
            console.log("set zoom factor to :" + value)
            web_view.zoomFactor = value
        }
    }
    Timer {
        id: timer
        interval: 1000; running: false; repeat: false;
        onTriggered: {
            console.log("xxxxxxxxxxx timer triggered")
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

    function loadHtml(html, baseUrl) {web_view.loadHtml(html, baseUrl);}
}
