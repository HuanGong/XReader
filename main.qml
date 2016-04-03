import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtWebEngine 1.2

import "qrc:/src/XReaderWindow.js" as XReader

import "src"

ApplicationWindow {
    id: xread_window
    visible: true
    width: 1280
    height: 720
    minimumHeight : 480
    minimumWidth : 640
    title: qsTr("XReader")

    menuBar: XMenu {
        id:main_menu
    }

    SplitView {
        id: splitView
        anchors.fill: parent

        Item {
            id: side_bar
            width: 240
            visible: true
            Layout.fillHeight: true
            Layout.maximumWidth: 280
            Layout.minimumWidth: 200

            StackView {
                id: stack_view
                anchors.fill: parent

                initialItem: FeedManagerView{
                    id: chanel_page
                    onSigChanelSelected: {
                        //article_list_view.model =  model_instance.feed
                        var article_list_view = article_list_component.createObject(stack_view);
                        article_list_view.setFeed(model_instance.feed)
                        article_list_view.articleClicked.connect(XReader.loadSelectedArticle);
                        article_list_view.backToMainPage.connect(XReader.backToFeedManagerView);
                        stack_view.push({item:article_list_view, destroyOnPop:true})
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

                Component {
                    id: article_list_component
                    ArticleListView{
                        id: article_list_view
                        anchors.fill: parent
                    }
                }
            }
        }

        Item {
            id: conten_view
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

            Loader { //the main content for display
                id: content_loader
                anchors.fill: parent
                source: "qrc:/src/RssContentWebView.qml"
            }

            Image {
                id: app_menu
                width: 24; height: 24
                anchors.top: parent.top; anchors.topMargin: 6;
                anchors.left: parent.left; anchors.leftMargin: 6
                source: "qrc:/image/icon/app.png"
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        if (content_loader.item.objectName != "XExploerer")
                            content_loader.source = "qrc:/src/snack/XExplorer.qml"
                        else
                            content_loader.source = "qrc:/src/RssContentWebView.qml"
                    }
                }
            }

            Image {
                id: img_view_max
                width: 18; height: 18
                anchors.top: parent.top;anchors.topMargin: 10
                anchors.right: parent.right;anchors.rightMargin: 10
                source: "qrc:/image/icon/view_max.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        side_bar.visible = !side_bar.visible;
                        if (stack_view.visible === true) {
                            img_view_max.source = "qrc:/image/icon/view_max.png"
                        } else {
                            img_view_max.source = "qrc:/image/icon/view-restore.png"
                        }

                    }
                }
            }
        }
    }

}
