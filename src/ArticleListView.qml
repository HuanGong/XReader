import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0


Item {
    signal backToMainPage()
    signal articleClicked(var model_instance)
    property alias status: rssModel.status

    id: article_list

    objectName: qsTr("ArticleList")
    anchors.fill: parent
    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        Rectangle {
            id: xreader_title
            z: 2; height: 48
            color: "#f69331"
            anchors.top: parent.top
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            Image {
                id: img_back
                width: 32; height: 32
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left; anchors.leftMargin: 4
                source: "qrc:/image/icon/app.png"
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
                width: 32; height: 32
                visible: !busyIndicator.running
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right; anchors.rightMargin: 4
                source: "qrc:/image/icon/refresh_list.png"
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
            //highlightFollowsCurrentItem: false
            focus: true

            model: XmlListModel {
                id: rssModel
                query: "/rss/channel/item"
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "title"; query: "title/string()" }
                XmlRole { name: "pubDate"; query: "pubDate/string()" }
                XmlRole { name: "content"; query: "description/string()" }

                onStatusChanged: {
                    if (status !== XmlListModel.Ready && status !== XmlListModel.Error) {
                        busyIndicator.running = true;
                    } else {
                        busyIndicator.running = false;
                    }
                }

                onSourceChanged: {
                    if (source !== "") {
                        busyIndicator.running = true
                    } else {
                        busyIndicator.running = false
                    }
                }
            }

            add: Transition {
                NumberAnimation { properties: "x,y"; from: 0; duration: 800 }
            }

            delegate: Item {
                width: parent.width; height: 36
                Rectangle {
                    radius: 4
                    opacity: 0.8
                    //color: "#87CEEB"
                    anchors.fill: parent
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.bottomMargin: 2
                    Item {
                        height: 18;//2*(height - 4)/3
                        anchors.top: parent.top;
                        anchors.left: parent.left; anchors.leftMargin: 2
                        anchors.right: parent.right; anchors.rightMargin: 2
                        Layout.fillWidth: true
                        Text {
                            id: rss_text
                            elide: Text.ElideRight
                            anchors.fill: parent
                            font.pointSize: 10
                            text: { return "<b>" + title + "</b>"; }
                        }
                    }
                    Item {
                        height: 14
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        Text {
                            id: pub_date
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right; anchors.rightMargin: 2
                            font.pointSize: 9
                            text: pubDate
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            article_list_view.currentIndex = index;
                            article_list.articleClicked(model)
                        }
                    }
                }
            }



            highlight: highlightBar
            Component { // Define a highlight with customized movement between items.
                id: highlightBar
                Rectangle {
                    id: higlight_rect
                    //width: article_list_view.width;
                    color: "#F4A460"
                    //x: article_list_view.currentItem.x;
                    //y: article_list_view.currentItem.y;
                    //Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
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
    }

    function setFeed(feed_source) {
        rssModel.source = feed_source;
    }
}
