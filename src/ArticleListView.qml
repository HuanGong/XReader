import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0

import "qrc:/src/js/HttpRequest.js" as Httpobj
//import "qrc:/src/js/Utils.qml" as Utils


Item {
    signal backToMainPage()
    signal articleClicked(var model_instance)

    property alias status: rssModel.status
    property alias feedsource: rssModel.source

    property real dpi: Screen.pixelDensity.toFixed(2)

    id: article_list

    objectName: qsTr("ArticleList")
    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        Rectangle {
            id: xreader_title
            z: 2; height: 48; color: "#f69331"
            anchors.top: parent.top
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            Image {
                id: img_back
                width: 24; height: 24
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left; anchors.leftMargin: 4
                source: "qrc:/image/icon/view-back.svg"; mirror: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rssModel.source = qsTr("");
                        backToMainPage()
                    }
                }
            }

            Image {
                id: img_reload
                width: 24; height: 24
                visible: !busyIndicator.running
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right; anchors.rightMargin: 4
                source: "qrc:/image/icon/view-reload.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        busyIndicator.running = true;
                        article_list_view.reload_feed()
                    }
                }
                BusyIndicator {
                  id: busyIndicator
                  width:24; height: 24
                  anchors.centerIn: parent
                  running: false
                }
            }
        }

        ListView {
            id: article_list_view
            spacing: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            highlightFollowsCurrentItem: true
            focus: true

            model: XmlListModel {
                id: rssModel
                query: "/rss/channel/item"
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "title"; query: "title/string()" }
                XmlRole { name: "pubDate"; query: "pubDate/string()" }
                XmlRole { name: "content"; query: "description/string()" }

                onStatusChanged: {
                    if (rssModel.status == XmlListModel.Loading) {
                        console.log("is loading: progress:", rssModel.progress)
                        busyIndicator.running = true;
                    } else if (rssModel.status == XmlListModel.Ready) {
                        console.log("The XML data has been loaded into the model")
                        busyIndicator.running = false;
                    } else if (rssModel.status == XmlListModel.Null) {
                        console.log("No XML data has been set for this model.")
                        busyIndicator.running = false;
                    } else if (rssModel.status == XmlListModel.Error) {
                        console.log("xmlistmodel error:", rssModel.errorString())
                        busyIndicator.running = false;
                    }
                }

                onSourceChanged: {
                    console.log(rssModel.source)
                    Httpobj.get(rssModel.source,
                             function(rs, jsonobj){
                                rssModel.xml = rs;
                                 //console.log("\n===========\n",rs, "\n============\n")
                             },
                             function (err, status) {
                                console.log(err, status)
                             } )
                }
            }

            /*add: Transition {
                NumberAnimation { properties: "x,y"; from: 0; duration: 800 }
            }*/

            delegate: Item {
                width: article_list_view.width; height: 14*dpi
                Rectangle {
                    radius: 4
                    opacity: 0.8
                    anchors.fill: parent
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.bottomMargin: 2
                    Item {
                        height: parent.height*2/3;
                        anchors.top: parent.top;
                        anchors.left: parent.left; anchors.leftMargin: 2
                        anchors.right: parent.right; anchors.rightMargin: 2
                        Layout.fillWidth: true; clip: true;
                        Text {
                            id: rss_text
                            clip:true;
                            font.pointSize: Utils.gu(14);
                            verticalAlignment: Text.AlignVCenter
                            text: { title }
                            NumberAnimation {
                                id:animText
                                target: rss_text
                                property: "x"
                                duration: 5000
                                from: 0
                                to: {
                                    if (parent.width - rss_text.contentWidth < 0)
                                        return parent.width - rss_text.contentWidth - 4*dpi;
                                    else
                                        return 0;
                                }
                                running: false
                                easing.type: Easing.OutCubic
                                onStopped: {
                                    if (article_list_view.currentIndex != index) {
                                        to = 0;
                                    } else {
                                        if (parent.width - rss_text.contentWidth < 0)
                                            to = parent.width - rss_text.contentWidth - 4*dpi;
                                        else
                                            to = 0;
                                    }
                                    animText.start();
                                }
                            }
                        }
                    }
                    Item {
                        height: parent.height/3;
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        Text {
                            id: pub_date
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right; anchors.rightMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: Utils.gu(10);
                            text: pubDate
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log(rss_text.text.length, rss_text.width);
                            if (article_list_view.currentIndex != index) {
                                article_list_view.currentIndex = index;
                                animText.start();
                            } else {
                                article_list_view.currentIndex = index;
                                article_list.articleClicked(model)
                            }

                        }
                    }
                }
            }



            highlight: highlightBar
            Component { // Define a highlight with customized movement between items.
                id: highlightBar
                Rectangle {
                    id: higlight_rect
                    color: "#F4A460"
                }
            }


            function reload_feed() {
                console.log('reloading')
                rssModel.reload()
            }
        }
    }

    Component.onDestruction: {
        console.log("article_list_view is going to die")
    }
    Component.onCompleted: {
        console.log("a new article_list_view created")
        busyIndicator.running = true;
    }

    function setFeed(feed_source) {
        rssModel.source = feed_source;
    }
}
