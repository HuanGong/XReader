import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtWebEngine 1.2
import QtQuick.Window 2.0

import "src"
import "src/js/XReaderWindow.js" as XReader
import "src/js/Utils.js" as Utils

ApplicationWindow {
    id: main_window
    visible: true
    width: Utils.gu(960); height: Utils.gu(520);
    minimumHeight : Utils.gu(460); minimumWidth : Utils.gu(720)
    title: qsTr("XReader")

    property alias sidebar: side_bar

    menuBar: XMenu {
        id:main_menu
        onSig_toggle_sidebar: {XReader.toggle_sidebar()}
    }

    Item {
        id: aaaaa
        signal sig_a(var a);
        anchors.fill: parent;
        SplitView {
            id: splitView
            anchors.fill: parent

            Item {
                id: side_bar
                width: Utils.gu(250);
                visible: true; clip: true
                Layout.fillHeight: true


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
                                    if (content_loader.item.objectName != "webview") {
                                        content_loader.source = "qrc:/src/ContentWebView.qml"
                                    }
                                    content_loader.item.weburl = model_instance.link
                                }
                            }

                        }
                    }
                    Component.onCompleted: {
                    }
                }
                PropertyAnimation {
                    id:animation_fadein; target: side_bar; properties: "width";
                    to: Utils.gu(240); easing.type: Easing.Linear; duration: 200;
                    onStarted: {side_bar.visible = true;}
                }
                PropertyAnimation {
                    id:animation_fadeout; target: side_bar; properties: "width";
                    to: 0; easing.type: Easing.InOutQuad; duration: 200;
                    onStopped: {
                        side_bar.visible = false;
                    }
                }
                onWidthChanged: {
                    if (width > Utils.gu(260)) {
                        width = Utils.gu(260)
                    }
                }
            }

            Item {
                id: conten_view
                anchors.right: parent.right
                Layout.fillHeight: true;
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                Loader { //the main content for display
                    id: content_loader;
                    anchors.fill: parent
                    source: "qrc:/src/ContentWebView.qml"
                }

                Connections {
                    id: loader_sig_connecter
                    target: content_loader.item; ignoreUnknownSignals: true;
                    onWv_fullview_clicked: {
                        XReader.toggle_sidebar();

                        console.log("onWv_request_max_view trigled")
                    }
                }
                Connections {
                    target: side_bar; ignoreUnknownSignals: true;
                    onVisibleChanged: {
                        if (content_loader.item.objectName == "webview")
                            content_loader.item.sidebarVisibilityChanged(side_bar.visible)
                    }
                }

                Image {
                    id: app_menu
                    width: 32; height: 32
                    anchors.top: parent.top; anchors.topMargin: 6;
                    anchors.left: parent.left; anchors.leftMargin: 6;
                    source: "qrc:/image/icon/application.svg"
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            XReader.openApplistView();
                        }
                    }
                }
            }
        }

        Image {
            id: bt_toggle_sidebar
            width: 22; height: 36; z: 2;
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; rotation: {side_bar.visible ? 180 : 0}
            source: "qrc:/image/icon/expand.svg"
            MouseArea {anchors.fill: parent;
                onClicked: {XReader.toggle_sidebar()}
            }
        }
    }
}

