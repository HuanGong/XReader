import QtQuick 2.4
import QtQuick.XmlListModel 2.0

import QtQuick.Controls 1.4


Item {
    signal sigOkPressed(var url, var name);
    signal sigComponentLoaded();

    id: dialogComponent
    anchors.fill: parent

    // Add a simple animation to fade in the popup, let the opacity go from 0 to 1 in 400ms
    PropertyAnimation { target: dialogComponent; property: "opacity";
        duration: 800; from: 0; to: 1;
        easing.type: Easing.InOutQuad ; running: true
    }

    // This rectange is the a overlay to partially show the parent through it
    // and clicking outside of the 'dialog' popup will do 'nothing'
    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6
        MouseArea {
            anchors.fill: parent
            onWheel: {}
        }
    }

    // This rectangle is the actual popup

    Rectangle {
        id: dialogWindow

        radius: 4
        width: 420; height: 240
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: tag_add_new_feed
            font.bold: true
            text: qsTr("Add New Feeds")
            anchors.top: parent.top; anchors.topMargin: 20
            anchors.left: parent.left; anchors.leftMargin: (parent.width-width)/2
        }

        Column {
            id: column
            spacing: 10
            anchors.top: parent.top; anchors.topMargin: 64
            anchors.left: parent.left; anchors.leftMargin: 16
            anchors.right: parent.right; anchors.rightMargin: 16

            Rectangle {
                id:row1
                radius: 4
                height: 32
                width: parent.width
                color: "#f69331"

                Text {
                    id: tag_feedurl
                    width: 64;height: 24
                    text: qsTr("Feed URL:")
                    anchors.left: parent.left
                    //anchors.leftMargin: 2
                    anchors.verticalCenter: parent.verticalCenter

                    //font.bold: true
                    font.pointSize: 12
                    textFormat: Text.PlainText
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
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.bottomMargin: 2


                    TextInput {
                        id: feed_url
                        clip: true
                        width: 200
                        height: 24
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        //horizontalAlignment: Text.AlignHCenter
                        text: qsTr("http://")
                        font.bold: false
                        font.pointSize: 10
                        cursorVisible: false
                        onFocusChanged: {
                            if (focus === false && text !== qsTr("http://")) {
                                console.log("Log::::::onFocusChanged")
                                feedTestModel.source = text
                            } else if (focus === true) {
                                feed_url.color = "dark"
                            }
                        }
                        Rectangle {
                            id: file_selector
                            radius: 2
                            color: "green"
                            opacity: 0.5
                            width: 12; height: 6;
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                        }
                    }
                    //statuscheck View
                }

                Rectangle {
                    id: img_feed_checker
                    color: "#000000"
                    width: 24
                    radius: 6
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    //anchors.left: textInputContainer.right
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.bottomMargin: 2
                }
            }
            Rectangle {
                id:row2
                radius: 4
                height: 32; width: parent.width
                color: "#f69331"

                Text {
                    id: tag_title
                    width: 64
                    height: 24
                    text: qsTr("Feed Title:")
                    anchors.left: parent.left
                    //anchors.leftMargin: 2
                    anchors.verticalCenter: parent.verticalCenter

                    //font.bold: true
                    font.pointSize: 12
                    textFormat: Text.PlainText
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
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.bottomMargin: 2

                    TextInput {
                        id: feed_name
                        clip: true
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        //horizontalAlignment: Text.AlignHCenter

                        text: qsTr("")
                        font.bold: false
                        font.pointSize: 10
                        cursorVisible: false
                        Text {
                            id: hint
                            opacity: 0.8
                            color: "gray"
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
                    //statuscheck View
                }
            }

        }

        Row {
            id: row
            spacing: 10
            //anchors.top: column.bottom; anchors.topMargin: 32
            //anchors.left: parent.left; anchors.leftMargin: 42
            anchors.right: parent.right; anchors.rightMargin: 32
            anchors.bottom: parent.bottom; anchors.bottomMargin: 32

            Button {
                id: bt_cancle
                //anchors.right: ok.left
                //anchors.rightMargin: 10
                anchors.leftMargin: 40
                text: qsTr("Cancel")
                //anchors.bottom: parent.bottom
                //anchors.bottomMargin: 20
                onClicked: {
                    dialogComponent.destroy();
                }
            }

            Button {
                id: bt_ok
                enabled: false
                anchors.leftMargin: 40
                text: qsTr("  Add  ");
                onClicked: {
                    if (feed_url.text.length == 0) {
                        console.log("please input correctly url")
                        return;
                    }
                    sigOkPressed(feed_url.text, feed_name.text);
                    dialogComponent.destroy();
                }
            }
        }

    }
    Component.onCompleted: {
        console.log("addnew feed dlg component loaded")
    }


    XmlListModel {
        id: feedTestModel
        //source: "https://developer.ubuntu.com/en/blog/feeds/"
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

