import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtWebView 1.1

import "src"

ApplicationWindow {
    id: xread_window
    visible: true
    width: 800
    height: 480
    color: "#929292"
    //minimumHeight : 640
    //minimumWidth : 400
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
            width: 300
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.maximumWidth: 320
            Layout.fillHeight: true
            onWidthChanged: {

            }

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
            }

            ArticleListView{
                id: article_list_view
                width: 320
                clip: false
                visible: false
                onClicked: {
                    console.log('pagestack created')
                    //article_content.text = model_instance.content
                    //content_02.text = model_instance.content
                    web_view.url = model_instance.link
                    //stack_view.push(article_content)
                }
                onBackToMainPage: {
                    console.log('slot onBackToMainPage tick')
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
            Text {
                id: content_02
                visible: false
                anchors.fill: parent
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                text: qsTr("这里将来要显示内容，也会显示一些插件上得东西， 比如说。。。")
            }
            WebView {
                id: web_view
                anchors.fill: parent
                url: "http://www.weixin.com"
            }

            Rectangle {
                id: bt_maximumContent
                width: 32; height: 32
                color: "#00633e"
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                radius: 16
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
