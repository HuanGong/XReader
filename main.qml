import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtWebEngine 1.2

import "src"

ApplicationWindow {
    id: xread_window
    visible: true
    width: 800
    height: 480
    color: "#929292"
    minimumHeight : 480
    minimumWidth : 640
    title: qsTr("XReader")

    menuBar: XMenu {
        id:main_menu
    }

    SplitView {
        id: splitView1
        anchors.fill: parent

        StackView {
            id: stack_view
            visible: true
            width: 240
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.maximumWidth: 300
            Layout.minimumWidth: 180
            Layout.fillHeight: true

            initialItem: chanel_page //article_list_view
            Component.onCompleted: {
                console.log('pagestack created')
                //stack_view.push(article_list_view);
            }

            FeedManagerView{
                id: chanel_page
                anchors.fill: parent
                onSigChanelSelected: {
                    console.log("onSigChanelSelected slot triged")
                    console.log(model_instance.feed)
                    stack_view.push(article_list_view)
                }

                onSigShowAddFeedView: {
                    var component = Qt.createComponent("qrc:/src/AddNewFeedView.qml");
                    if (component.status === Component.Ready)
                        component.createObject(xread_window, {});
                    else
                        console.log("conmentnet not ready"+ component.errorString())
                }

            }

            ArticleListView{
                id: article_list_view
                width: 320
                clip: false
                visible: false
                onClicked: {
                    console.log('article_list_view  onClicked')
                    //web_view.url = model_instance.link
                    web_view.loadHtml(model_instance.content, model_instance.link)
                    //stack_view.push(article_content)
                }
                onBackToMainPage: {
                    console.log('onBackToMainPage')
                    chanel_page.visible = true
                    stack_view.pop()
                }
            }

            ArticleContent {
                id: article_content
                anchors.fill: parent
                visible: false
            }
        }

        Rectangle {
            id: rssContenView
            width: 200
            color: "#ffffee"
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            border.color: "#ee2828"
            border.width: 2
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            WebEngineView {

                id: web_view
                anchors.fill: parent
                url: "http://www.apple.com"
                zoomFactor: 4
                onLoadProgressChanged: {
                    if (loadProgress > 79) {
                        scheduleZoom();
                    }
                }
                onLoadingChanged: {
                    console.log("loading changed.....")
                }

                Component.onCompleted: {
                    web_view.settings.pluginsEnabled = true;
                    web_view.settings.javascriptCanOpenWindows = false;
                    web_view.settings.spatialNavigationEnabled = false;
                    zoomFactor: zoom_size.value
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
            }


            Slider {
                id: zoom_size
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

            Rectangle {
                id: bt_maximumContent
                width: 16; height: 16
                color: "#00633e"
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                radius: 8
                opacity: 0.75
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stack_view.visible = !stack_view.visible
                    }
                }
            }
        }
    }

}
