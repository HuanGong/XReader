import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtWebEngine 1.2
import QtQuick.Window 2.0

import "src"
import "qrc:/src/XReaderWindow.js" as XReader



ApplicationWindow {
    id: main_window
    visible: true
    width: 400*dpi
    height: 220*dpi
    minimumHeight : 480
    minimumWidth : 800
    title: qsTr("XReader")

    property real dpi: Screen.pixelDensity.toFixed(2)

    menuBar: XMenu {
        id:main_menu
    }

    SplitView {
        id: splitView
        anchors.fill: parent

        Item {
            id: side_bar
            width: 100*dpi
            visible: true
            Layout.fillHeight: true
            Layout.maximumWidth: 160*dpi
            Layout.minimumWidth: 80*dpi

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
                            var dlg = component.createObject(main_window, {});
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
            Component.onCompleted: {
                console.log("in 720p: dpi is:", dpi)
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
                source: "qrc:/src/ContentWebView.qml"
            }

            Image {
                id: app_menu
                width: 32; height: 32
                anchors.top: parent.top; anchors.topMargin: 6;
                anchors.left: parent.left; anchors.leftMargin: 6;
                source: "qrc:/image/icon/app-launcher.png"
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        XReader.openApplistView();
                    }
                }
            }

            Image {
                id: img_view_max
                width: 22; height: 22
                anchors.top: parent.top;anchors.topMargin: 6
                anchors.right: parent.right;anchors.rightMargin: 6
                source: "qrc:/image/icon/view-fullscreen.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        side_bar.visible = !side_bar.visible;
                        if (stack_view.visible === true) {
                            img_view_max.source = "qrc:/image/icon/view-fullscreen.png"
                        } else {
                            img_view_max.source = "qrc:/image/icon/view-restore.png"
                        }

                    }
                }
            }
        }
    }

}
