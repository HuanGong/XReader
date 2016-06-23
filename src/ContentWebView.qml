import QtQuick 2.0
import QtWebEngine 1.2
import QtQuick.Controls 1.4

import "readability.js" as Reader

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
        web_view.settings.pluginsEnabled = false;
        web_view.settings.javascriptEnabled = false;
        web_view.settings.javascriptCanOpenWindows = false;
        web_view.settings.spatialNavigationEnabled = false;
    }

    BusyIndicator{
        id: busyIndicator
        z: 2; running: true
        anchors.centerIn: parent
    }

    Rectangle {
        property real itemsize: 16

        id: wv_lens; z: 2

        width: itemsize; height: itemsize*4;
        opacity: 0.85; radius: 2; clip: true;
        anchors.top: parent.top; anchors.topMargin: 4;
        anchors.right: parent.right; anchors.rightMargin: 4;

        Column {
            spacing: 1
            Rectangle {
                id: fullscreen; radius: 2;
                width: wv_lens.itemsize; height: width
                color: "#ffffff"
                Image {
                    id: img_view_max
                    anchors.fill: parent
                    source: "qrc:/image/icon/view-fullscreen.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {/*
                        side_bar.visible = !side_bar.visible;
                        if (stack_view.visible === true) {
                            img_view_max.source = "qrc:/image/icon/view-fullscreen.png"
                        } else {
                            img_view_max.source = "qrc:/image/icon/view-restore.png"
                        }*/

                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("reader mode fucked")
                    }
                }
            }
            Rectangle {
                id: reader; radius: 2;
                width: wv_lens.itemsize; height: width
                //anchors.left: zoom_out.right
                color: "#0000ff"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("reader mode fucked")
                        var reader = new Reader.Readability();
                        reader.readabilityGet(web_view.url, onGetReadabilityData, onReadabilityGetErr)
                    }
                }
            }
            Rectangle {
                id: zoom_in; radius: 2;
                width: wv_lens.itemsize; height: width
                color: "#ff0000"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        web_view.zoomFactor -= 0.1
                    }
                }
            }
            Rectangle {
                id: zoom_out; radius: 2;
                width: wv_lens.itemsize; height: width
                color: "#00ff00"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        web_view.zoomFactor += 0.1
                        console.log("reader mode fucked")
                    }
                }
            }
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
