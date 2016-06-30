import QtQuick 2.0
import QtQuick.Dialogs 1.0

Item {
    id: youtubedlview
    property int marginsize: 12
    anchors.fill: parent
    Rectangle{
        id: drop_area
        height: 48; width: youtubedlview.width
        color: "#f69331"; opacity: 0.75; radius: 2
        Text {
            anchors.centerIn: parent
            text: qsTr("Drag video Url Here")
        }
    }
    Column {//行
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8;
        anchors.top: drop_area.bottom
        anchors.topMargin:  42; spacing: 8
        move: Transition{ NumberAnimation {properties: "x,y"; duration: 1000}}

        Item {
            id: url_info
            width: youtubedlview.width; height: 32;
            Rectangle {
                id: url_info_container; anchors.fill: parent;  clip: true;
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
                Row {
                    spacing: 2
                    Rectangle{
                        id: tag_url_container;color: "lightgray";
                        width: 48; height: 32; radius: 2;
                        Text {
                            id: tag_url;
                            anchors.centerIn: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: qsTr("URL:")
                        }
                    }
                    Rectangle {
                        id: input_url_container;
                        anchors.verticalCenter: parent.verticalCenter;
                        height: 32; clip: true; color: "lightgray"; radius: 2;
                        width: url_info_container.width-tag_url_container.width
                        TextInput{
                            id: input_url;selectByMouse: true;clip: true;
                            anchors.fill: parent;
                            anchors.leftMargin: 2; anchors.rightMargin: 2
                            //anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            //horizontalAlignment: Text.AlignHCenter
                            text: qsTr("填写你播放视频的网址....")
                        }
                    }
                }
            }
        }
        Item {
            id: save_file_info
            width: youtubedlview.width; height: 32;
            Rectangle {
                id: save_file_container; anchors.fill: parent;
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
                clip: true; color: "lightgray"; radius: 2
                Text {
                    id: save_as_file;
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Choose a place file save.....")
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        fileDialog.open();
                    }
                }
            }
        }
        Item {
            id: network_info
            width: youtubedlview.width; height: 48;
            Rectangle {
                id: networksetting_container; anchors.fill: parent;
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
                clip: true; color: "lightgray"; radius: 2
                Text {
                    id: networksetting;
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("网络不通.... 有代理 ? 点我设置代理 : 您还是去别处逛逛吧...")
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {

                    }
                }
            }
        }

        Item {
            id: video_preview
            width: youtubedlview.width; height: parent.height - y;

            Rectangle {
                anchors.fill: parent; radius: 4; color: "lightgray";
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
            }
            MouseArea {
                anchors.fill: parent
                //onClicked: video_preview.visible = !video_preview.visible
            }
        }

    }

    FileDialog {
        id: fileDialog
        title: "Please choose a folder"
        folder: shortcuts.home;
        selectFolder: true; selectMultiple: false;
        onAccepted: {
            console.log("You chose: " + fileDialog.folder)
        }
        onRejected: {
            console.log("Canceled")
        }
        Component.onCompleted: visible = false
    }

}
