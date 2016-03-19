import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0


Item {
    id: article_list
    signal clicked(var model_instance)
    signal backToMainPage()
    property alias status: rssModel.status

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            id: xreader_title
            z: 2
            width: 200; height: 64
            color: "#f69331"
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        }

        ListView {
            id: article_list_view
            z: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            model: XmlListModel {
                id: rssModel
                source: "https://developer.ubuntu.com/en/blog/feeds/"
                query: "/rss/channel/item"
                XmlRole { name: "title"; query: "title/string()" }
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "published"; query: "pubDate/string()" }
                XmlRole { name: "content"; query: "description/string()" }
            }

            add: Transition {
                NumberAnimation { properties: "x,y"; from: 0; duration: 1000 }
            }

            delegate: Rectangle {
                width: parent.width
                height: 24
                color: "#f69331"
                Rectangle {
                    width: parent.width
                    height: 23
                    color: "#AEAEAE"
                    Text {
                        id: rss_text
                        anchors.centerIn: parent
                        font.pointSize: 8
                        text: { return "<b>" + published + "</b>"; }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("send a signal clicked")
                            article_list.clicked(model)
                        }
                    }
                }

            }

            // Define a highlight with customized movement between items.
            Component {
                id: highlightBar
                Rectangle {
                    width: parent.width; height: 25
                    color: "#FFFF88"
                    y: listView.currentItem.y;
                    Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
                }
            }


            //highlight: highlightBar
            //Scrollbar {
            //flickableItem: listView
            //}
            function reload_feed() {
                console.log('reloading')
                rssModel.reload()
            }
        }
    }

    Rectangle {
        id: back
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 42; height: 42
        radius: 20
        color: "#aa0033"
        Text {
            id: back_text
            anchors.centerIn: parent
            text: qsTr("back")
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log('bt_backToMainView Triged')
                backToMainPage()

            }
        }
    }

    Rectangle {
        id: reload
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 42; height: 42
        radius: 20
        color: "#aa0033"
        Text {
            id: reload_text
            anchors.centerIn: parent
            text: qsTr("Reload")
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log('bt_reload_feed triged')
                article_list_view.reload_feed()
            }
        }
    }

}
