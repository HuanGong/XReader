import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

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
                    //article_list_view.model =  model_instance.feed
                    article_list_view.setFeed(model_instance.feed)
                    stack_view.push(article_list_view)
                }

                onSigShowAddFeedView: {
                    var component = Qt.createComponent("qrc:/src/AddNewFeedView.qml");
                    if (component.status === Component.Ready) {
                        var dlg = component.createObject(xread_window, {});
                        dlg.sigOkPressed.connect(chanel_page.onAddNewFeed);
                    } else {
                        console.log("conmentnet not ready"+ component.errorString())

                    }
                }

            }

            ArticleListView{
                id: article_list_view
                width: 320
                clip: false
                visible: false
                onClicked: {
                    console.log('article_list_view  onClicked')
                    if (content_loader.item.objectName == "webview") {
                        //web_view.url = model_instance.link
                        console.log("start loading a new url")
                        content_loader.item.weburl = model_instance.link
                    }
                    //web_view.loadHtml(model_instance.content, model_instance.link)
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

            Loader {
                id: content_loader
                anchors.fill: parent
                source: "qrc:/src/RssContentWebView.qml"
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
                        //stack_view.visible = !stack_view.visible
                        if (content_loader.item.objectName === "webview") {
                            content_loader.source = "qrc:/src/snack/XExplorer.qml"
                        } else {
                            content_loader.source = "qrc:/src/RssContentWebView.qml"
                        }


                        if (false && content_loader.item.objectName == "webview") {
                            //web_view.url = model_instance.link
                            console.log("start loading a new url")
                            content_loader.item.iswebview();
                            content_loader.item.weburl = "http://www.baidu.com"
                        }
                    }
                }
            }
        }
    }

}
