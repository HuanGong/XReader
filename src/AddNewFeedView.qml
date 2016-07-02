import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtWebEngine 1.2
import QtQuick.Controls 1.4
import "js/Utils.js" as Utils

Item {
    signal sigOkPressed(var url, var name);
    signal sigComponentLoaded();

    id: dialogComponent
    anchors.fill: parent

    // Add a simple animation to fade in the popup, let the opacity go from 0 to 1 in 400ms
    PropertyAnimation {
        target: dialogComponent; property: "opacity"; duration: 800;
        from: 0; to: 1; easing.type: Easing.InOutQuad ; running: true
    }

    // This rectange is the a overlay to partially show the parent through it
    // and clicking outside of the 'dialog' popup will do 'nothing'
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "#000000"; opacity: 0.6
        MouseArea { anchors.fill: parent; onWheel: {}}
    }

    // This rectangle is the actual popup
    Rectangle {
        id: dialogWindow

        radius: 4
        width: Utils.gu(420); height: Utils.gu(240)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: tag_add_new_feed
            font.bold: true; font.pointSize: Utils.gu(15)
            text: qsTr("Add New Feeds")
            anchors.top: parent.top; anchors.topMargin: Utils.gu(24)
            anchors.left: parent.left; anchors.leftMargin: (parent.width-width)/2
        }

        Column {
            id: column
            spacing: Utils.gu(10)
            anchors.top: tag_add_new_feed.bottom; anchors.topMargin: Utils.gu(20)
            anchors.left: parent.left; anchors.leftMargin: Utils.gu(12)
            anchors.right: parent.right; anchors.rightMargin: Utils.gu(12)

            Rectangle {
                id:row1
                radius: Utils.gu(4); color: "#f69331"
                width: parent.width; height: Utils.gu(32)

                Text {
                    id: tag_feedurl; height: Utils.gu(24)
                    text: qsTr("Feed URL:"); clip: true; textFormat: Text.PlainText
                    anchors.left: parent.left; anchors.leftMargin: Utils.gu(2)
                    anchors.verticalCenter: parent.verticalCenter

                    font.pointSize: Utils.gu(13);
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    id: textInputContainer
                    radius: 4
                    color: "pink"
                    anchors.top: parent.top
                    anchors.right: img_feed_checker.left
                    anchors.bottom: parent.bottom
                    anchors.left: tag_feedurl.right
                    anchors.topMargin: 2*Utils.gu(1)
                    anchors.leftMargin: 2*Utils.gu(1)
                    anchors.rightMargin: 2*Utils.gu(1)
                    anchors.bottomMargin: 2*Utils.gu(1)

                    TextInput {
                        id: feed_url
                        clip: true; selectByMouse: true;
                        anchors.fill: parent; verticalAlignment: Text.AlignVCenter
                        text: qsTr("http://"); cursorVisible: false
                        font.pointSize: Utils.gu(11);
                        onFocusChanged: {
                            if (focus === false && text !== qsTr("http://")) {
                                feedTestModel.source = text
                            } else if (focus === true) {
                                feed_url.color = "dark"
                            }
                        }
                        Rectangle {
                            id: file_selector
                            radius: 2*Utils.gu(1);
                            color: "green"
                            opacity: 0.5
                            width: 12*Utils.gu(1); height: 6*Utils.gu(1);
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                        }
                    }
                }

                Rectangle {
                    id: img_feed_checker
                    color: "#000000"
                    width: 24; radius: 6
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 2; anchors.leftMargin: 2
                    anchors.rightMargin: 2; anchors.bottomMargin: 2
                }
            }
            Rectangle {
                id:row2
                radius: Utils.gu(4);color: "#f69331"
                height: Utils.gu(32); width: parent.width
                Text {
                    id: tag_title
                    height: Utils.gu(24)
                    text: qsTr("Feed Title:")
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    font.pointSize: Utils.gu(13);
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Rectangle {
                    id: feedTitleContainer
                    radius: 4
                    color: "pink"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.left: tag_title.right
                    anchors.topMargin: 2*Utils.gu(1)
                    anchors.leftMargin: 2*Utils.gu(1)
                    anchors.rightMargin: 2*Utils.gu(1)
                    anchors.bottomMargin: 2*Utils.gu(1)

                    TextInput {
                        id: feed_name
                        clip: true; selectByMouse: true;
                        anchors.fill: parent; verticalAlignment: Text.AlignVCenter

                        font.pointSize: Utils.gu(10)
                        text: qsTr(""); cursorVisible: false

                        Text {
                            id: hint
                            opacity: 0.8; color: "gray"
                            font.pointSize: Utils.gu(10)
                            anchors.centerIn: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: qsTr("give a title here")
                        }
                        onFocusChanged: {
                            if (focus === true) {
                                hint.visible = false;
                            } else {
                                var real_text = text.replace(/^\s+|\s+$/g, '' );
                                if (real_text !== qsTr("")) {
                                    hint.visible = false;
                                } else {
                                    hint.visible = true;
                                }
                            }
                        }
                    }
                }
            }

        }

        Row {
            id: row
            spacing: Utils.gu(10)
            anchors.right: parent.right; anchors.rightMargin: Utils.gu(32)
            anchors.bottom: parent.bottom; anchors.bottomMargin: Utils.gu(32)

            Button {
                id: bt_cancle
                anchors.leftMargin: Utils.gu(48)
                width: Utils.gu(48);height: Utils.gu(22);
                text: qsTr("Cancel");
                onClicked: {
                    dialogComponent.destroy();
                }
            }

            Button {
                id: bt_ok
                enabled: false; anchors.leftMargin: Utils.gu(48)
                width: Utils.gu(48); height: Utils.gu(22);
                text: qsTr("  Add  ");
                onClicked: {
                    if (feed_url.text.length == 0) {
                        return;
                    }
                    sigOkPressed(feed_url.text, feed_name.text);
                    dialogComponent.destroy();
                }
            }
        }

    }
    Component.onCompleted: {
        console.log("add new feed dlg component loaded")
    }

    XmlListModel {
        id: feedTestModel
        query: "/rss/channel/item"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "published"; query: "pubDate/string()" }
        onStatusChanged: {
            if (status === XmlListModel.Error) {
                console.log("error xml parse")
                feedVerifyFailed();
            } else if (status === XmlListModel.Loading) {
                img_feed_checker.color = "blue"
            } else if (status === XmlListModel.Ready) {
                var title = feedTestModel.get(0)
                console.log(title)
                if (title !== undefined) {
                    console.log("xmlListModel.Ready xml parse")
                    feedVerifySuccess();
                } else {
                    feedVerifyFailed();
                }
            }
        }

    }

    function feedVerifyFailed() {
        bt_ok.enabled = false
        feed_url.color = "red"
        img_feed_checker.color = "red"
    }

    function feedVerifySuccess() {
        bt_ok.enabled = true
        img_feed_checker.color = "green"
    }

}

