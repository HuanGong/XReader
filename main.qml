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
    width: minimumWidth
    height: minimumHeight
    minimumHeight : Screen.height*2/3
    minimumWidth : Screen.width*2/3
    title: qsTr("XReader")

    property real dpi: Screen.pixelDensity.toFixed(2)

    menuBar: XMenu {
        id:main_menu
        //__contentItem.transform: Scale {yScale: 0}
        onSig_toggle_sidebar: {side_bar.visible ? animation_fadeout.start(): animation_fadein.start();}
    }

    SplitView {
        id: splitView
        anchors.fill: parent

        Item {
            id: side_bar
            width: 90*dpi
            visible: true
            Layout.fillHeight: true
            //Layout.maximumWidth: 140*dpi
            //Layout.minimumWidth: 100*dpi

            StackView {
                id: stack_view
                anchors.fill: parent

                initialItem: FeedManagerView {
                    id: chanel_page
                    onSigChanelSelected: {
                        //stackView.push({item: someItem, properties: {fgcolor: "red", bgcolor: "blue"}})
                        stack_view.push({item: article_list_component, properties: {feedsource: model_instance.feed}})
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

                    Component {
                        id: article_list_component
                        ArticleListView{
                            id: article_list_view
                            onBackToMainPage: {stack_view.pop();}
                            onArticleClicked: {
                                //side_bar.visible = false;
                                content_loader.item.weburl = model_instance.link
                            }
                        }

                    }
                }
                Component.onCompleted: {
                    console.log("in 720p: dpi is:", dpi)
                }
            }
            PropertyAnimation {id:animation_fadein; target: side_bar; properties: "width"; to: 100*dpi; easing.type: Easing.Linear; duration: 200;
                onStarted: {
                    side_bar.visible = true;
                }
            }
            PropertyAnimation {id:animation_fadeout; target: side_bar; properties: "width"; to: 0; easing.type: Easing.Linear; duration: 200;
                onStopped: {
                    side_bar.visible = false;
                }
            }
        }

        Item {
            id: conten_view
            anchors.right: parent.right
            Layout.fillHeight: true;
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

            Loader { //the main content for display
                id: content_loader
                anchors.fill: parent
                source: "qrc:/src/ContentWebView.qml"

            }

            Connections {
                id: loader_sig_connecter
                target: content_loader.item; ignoreUnknownSignals: true;
                onWv_fullview_clicked: {
                    //side_bar.visible = !side_bar.visible;
                    side_bar.visible ? animation_fadeout.start(): animation_fadein.start();
                    //content_loader.item.sidebarVisibilityChanged(side_bar.visible)
                    console.log("onWv_request_max_view trigled")
                }
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
        }
    }

}

