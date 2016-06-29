import QtQuick 2.0

Item {
    id: youtubedlview
    anchors.fill: parent
    Column {
        anchors.fill: parent
        Rectangle{
            height: 48; width: youtubedlview.width
            color: "#f69331"; opacity: 0.75
            Text {
                anchors.centerIn: parent
                text: qsTr("Drag video Url Here")
            }
        }
        Rectangle{
            width: youtubedlview.width - 20; height: 32;
            Row {
                anchors.fill: parent;
                Rectangle{
                    color: "#f69331"; radius: 2; id: tag_url_container
                    width: tag_url.implicitWidth + 10
                    height: tag_url.implicitHeight + 10
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: tag_url; anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("URL:")
                    }
                }
                Rectangle {
                    color: "#f69331"; radius: 2;
                    width: parent.width - tag_url_container.width
                    height: parent.height
                    anchors.left: tag_url_container.right;
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    TextInput{
                        id: input_url;selectByMouse: true;
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("填写你播放视频的网址....")
                    }
                }
            }
        }
    }

    //anchors.centerIn: parent;

}
