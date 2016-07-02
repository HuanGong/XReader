import QtQuick 2.0
import QtWebEngine 1.2
import QtQuick.Controls 1.4

import "js/readability.js" as Reader
import "js/Utils.js" as Utils

WebEngineView {
    signal wv_fullview_clicked();
    property alias weburl: web_view.url
    property alias zoomfactor: web_view.zoomFactor

    id: web_view;
    visible: true
    objectName: "webview"
    anchors.fill: parent
    url: "qrc:/wellcome/resource/wellcome.html"
    zoomFactor: 1
    onLoadProgressChanged: {
        progress_bar.visible = true;
        if (loadProgress < progress_bar.queue[progress_bar.queue.length-1] ||
            loadProgress === progress_bar.queue[progress_bar.queue.length-1] ) {
            return;
        }
        if (loadProgress - progress_bar.queue[progress_bar.queue.length-1] > 25) {
            progress_bar.queue.push((loadProgress + progress_bar.queue[progress_bar.queue.length-1])/2)
            progress_bar.queue.push(loadProgress)
        } else {
            progress_bar.queue.push(loadProgress)
        }

        if(!progress_animation.running) {
            progress_animation.start();
        }
    }
    onUrlChanged: {progress_bar.reset();}

    Rectangle {
        id: progress_bar; color: "#f69331";

        property var queue: [];
        anchors.top: parent.top; z: 2;
        width: 0; height: 4;
        NumberAnimation {
            id: progress_animation; properties: "width"; duration: 300;
            target: progress_bar;
            onStopped: {
                if (progress_bar.queue.length > 0) {
                    from = progress_bar.width;
                    to = progress_bar.queue.splice(0,1)[0]/100 * web_view.width;
                    console.log("restart animation from:",from," to:", to)
                    start();
                }
                if (progress_bar.width == web_view.width) {
                    delay_timer.start();
                }
            }
        }
        Timer {
            id: delay_timer
            interval: 1000; repeat: false;
            onTriggered: {progress_bar.reset();}
        }
        function reset() {
            progress_bar.visible = false;
            progress_bar.width = 0;
            progress_bar.queue = [];
            progress_animation.to = 0;
            progress_animation.from = 0;
        }
    }

    Component.onCompleted: {
        web_view.settings.pluginsEnabled = false;
        web_view.settings.javascriptEnabled = true;
        web_view.settings.javascriptCanOpenWindows = false;
        web_view.settings.spatialNavigationEnabled = false;

        console.log(web_view.profile.httpUserAgent);
        var android = "Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36"
        var ipad = "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
        var iphone = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
        var firfox = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0"
        web_view.profile.httpUserAgent = iphone;

    }

    BusyIndicator{
        id: busyIndicator
        z: 2; running: false
        anchors.centerIn: parent
    }

    Item {
        property real itemsize: Utils.gu(18)

        id: wv_lens; z: 2
        width: itemsize; height: itemsize*4;
        opacity: 0.85; clip: true;
        anchors.top: parent.top; anchors.topMargin: 4;
        anchors.right: parent.right; anchors.rightMargin: 16;

        Column {
            spacing: 1
            Image {
                id: img_view_max;
                width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/view-fullscreen.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {wv_fullview_clicked();}
                }
            }
            Image {
                id: reader;width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/mode_reader.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("reader mode fucked")
                        var reader = new Reader.Readability();
                        reader.readabilityGet(web_view.url,
                                              onGetReadabilityData,
                                              onReadabilityGetErr)
                    }
                }
            }
            Image {
                id: zoom_in;
                width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/zoom-out.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        web_view.zoomFactor -= 0.1
                    }
                }
            }
            Image {
                id: zoom_out;
                width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/zoom-in.svg"
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

    function sidebarVisibilityChanged(visible) {
        img_view_max.source = visible ? "qrc:/image/icon/view-fullscreen.svg"
                                      : "qrc:/image/icon/view-restore.svg"
    }

    function iswebview() {return true;}

    function loadUrl(url) {web_view.url = url;}

    function loadFromHtmlString(html, baseUrl) {web_view.loadHtml(html, baseUrl);}

    function onGetReadabilityData(res, data) {
        console.log("get get get get get ......")
        web_view.loadFromHtmlString(data.content, web_view.url)
    }

    function onReadabilityGetErr(res, status) {
        console.log("readability parse error......")
    }

}
