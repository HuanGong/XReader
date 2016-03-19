import QtQuick 2.4
import QtQuick.XmlListModel 2.0

import QtQuick.Controls 1.4


Item {
    signal sigComponentLoaded();

    id: dialogComponent
    anchors.fill: parent

    // Add a simple animation to fade in the popup
    // let the opacity go from 0 to 1 in 400ms
    PropertyAnimation { target: dialogComponent; property: "opacity";
        duration: 400; from: 0; to: 1;
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
        }
    }

    // This rectangle is the actual popup
    Rectangle {
        id: dialogWindow
        width: 420
        height: 240
        radius: 4
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: tag_feedurl
            y: 44
            width: 89
            height: 35
            text: qsTr("Feed URL:")
            anchors.left: parent.left
            anchors.leftMargin: 64
            font.bold: true
            font.pointSize: 13
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenterOffset: -65
            anchors.verticalCenter: parent.verticalCenter
        }

        TextInput {
            id: feed_url
            y: 37
            width: 200
            height: 35
            text: qsTr("url")
            font.pixelSize: 13
            selectionColor: "#d4ea63"
            horizontalAlignment: Text.AlignHCenter
            anchors.left: tag_feedurl.right
            anchors.leftMargin: 4
        }

        Button {
            id: ok

            enabled: false
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            text: qsTr("  Add  ");
            onClicked: {
                if (feed_url.text.length == 0) {
                    console.log("please input correctly url")
                    return;
                    //check the feed is right
                }
                dialogComponent.destroy();
            }
        }

        Button {
            id: cancle
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.right: ok.left
            anchors.rightMargin: 10
            text: qsTr("CanCle")
            onClicked: {
                dialogComponent.destroy();
            }
        }
    }

    Component.onCompleted: {
        console.log("addnew feed dlg component loaded")
        sigComponentLoaded();
    }


    XmlListModel {
        id: rssModel
        //source: "https://developer.ubuntu.com/en/blog/feeds/"
        query: "/rss/channel/item"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "published"; query: "pubDate/string()" }
        XmlRole { name: "content"; query: "description/string()" }

    }

}

