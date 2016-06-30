import QtQuick 2.0
import QtWebEngine 1.2
import QtQuick.Controls 1.4

import "js/readability.js" as Reader

WebEngineView {
    signal wv_fullview_clicked();
    //signal articleClicked(var model_instance)
    property alias weburl: web_view.url
    property alias zoomfactor: web_view.zoomFactor

    id: web_view;
    visible: true
    objectName: "webview"
    anchors.fill: parent
    url: "https://huangong.gitbooks.io/art_as_programer/content/program_project/the_x-th_project_xreader.html"
    zoomFactor: 1
    onLoadProgressChanged: {
        if (loadProgress - progress_bar.queue[progress_bar.queue.length-1] > 25) {
            progress_bar.queue.push((loadProgress + progress_bar.queue[progress_bar.queue.length-1])/2)
            progress_bar.queue.push(loadProgress)
        } else if(loadProgress !== progress_bar.queue[progress_bar.queue.length-1]) {
            progress_bar.queue.push(loadProgress)
        }

        if(!progress_animation.running) {
            progress_animation.start();
        }
        console.log(progress_bar.queue);
    }
    onLoadingChanged: {
        console.log("loading changed.....:", loading ? "loading" : "stoped")
        //busyIndicator.running = loading;
    }
    onUrlChanged: {
        if (progress_animation.running) {
           progress_bar.queue = [];
           progress_animation.stop();
        }
    }

    Rectangle {
        id: progress_bar; color: "#f69331";

        property var queue: [];
        anchors.top: parent.top; z: 2;
        width: 0; height: 6; radius: 1;
        //PropertyAnimation {
        NumberAnimation {
            id: progress_animation; properties: "width"; duration: 100;
            target: progress_bar;// from: progress_bar.old; to: width
            onStopped: {
                if(progress_bar.queue.length > 0) {
                    from = progress_bar.width;
                    to = progress_bar.queue.splice(0,1)[0]/100 * web_view.width;
                    console.log("restart animation from:",from," to:", to)
                    start();
                } else if(web_view.width == progress_bar.width && !web_view.loading && progress_bar.queue.length == 0){
                    console.log("set progress bar width to 0")
                    progress_bar.width = 0;
                }
            }
        }
        onWidthChanged: {
            //progress_animation.start();
        }
        Component.onCompleted: {

        }

        /*
        Behavior on width {
            PropertyAnimation {
                id: progress_animation; duration: 500;
                onRunningChanged: {
                    if(width == web_view.width && running == false) {
                        progress_bar.visible = false;
                        progress_bar.width = 0;
                    }
                }
            }
        }*/
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

    Item {
        property real itemsize: 8*dpi

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
