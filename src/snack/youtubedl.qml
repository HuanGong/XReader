import QtQuick 2.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.4

import "../js/Utils.js" as Utils
Item {
    id: youtubedlview
    property int marginsize: Utils.gu(12)
    anchors.fill: parent
    Rectangle{
        id: drop_area
        height: Utils.gu(48); width: youtubedlview.width
        color: "#f69331"; opacity: 0.75; radius: Utils.gu(2)
        Text {
            anchors.centerIn: parent
            font.pointSize: Utils.gu(13)
            text: qsTr("Drag video Url Here")
        }
    }
    Column {//行
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Utils.gu(8);
        anchors.top: drop_area.bottom
        anchors.topMargin:  Utils.gu(24); spacing: Utils.gu(8)
        move: Transition{ NumberAnimation {properties: "x,y"; duration: 1000}}

        Button {
            id: start
            text: qsTr("Start");
            width: Utils.gu(64); height: 32;
            onClicked: {
                var outputname = save_as_file.text + "%(title)s.%(ext)s"
                startDownloadWork("./youtube-dl", ["--proxy=127.0.0.1:8087",
                                                   "--output=" + outputname,
                                                   "https://www.youtube.com/watch?v=11yUVvyp2Hs"])
            }
        }

        Item {
            id: url_info
            width: youtubedlview.width; height: Utils.gu(32);
            Rectangle {
                id: url_info_container; anchors.fill: parent;  clip: true;
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
                Row {
                    spacing: Utils.gu(2)
                    Rectangle{
                        id: tag_url_container;color: "lightgray";
                        width: Utils.gu(48); height: Utils.gu(32); radius: Utils.gu(2);
                        Text {
                            id: tag_url;
                            anchors.centerIn: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: Utils.gu(13)
                            text: qsTr("URL:")
                        }
                    }
                    Rectangle {
                        id: input_url_container;
                        anchors.verticalCenter: parent.verticalCenter;
                        height: Utils.gu(32); clip: true; color: "lightgray"; radius: Utils.gu(2);
                        width: url_info_container.width-tag_url_container.width
                        TextInput{
                            id: input_url;selectByMouse: true;clip: true;
                            anchors.fill: parent;
                            anchors.leftMargin: Utils.gu(2);
                            anchors.rightMargin: Utils.gu(2);
                            font.pointSize: Utils.gu(13);
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("填写你播放视频的网址....")
                        }
                    }
                }
            }
        }
        Item {
            id: save_file_info
            width: youtubedlview.width; height: Utils.gu(32);
            Rectangle {
                id: save_file_container; anchors.fill: parent;
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
                clip: true; color: "lightgray"; radius: Utils.gu(2)
                Text {
                    id: save_as_file;
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: Utils.gu(13)
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
            width: youtubedlview.width; height: Utils.gu(48);
            Rectangle {
                id: networksetting_container; anchors.fill: parent;
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
                clip: true; color: "lightgray"; radius: Utils.gu(2)
                Text {
                    id: networksetting;
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: Utils.gu(13)
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

            TextArea {
                anchors.fill: parent;
                id: logger;
                anchors.leftMargin: marginsize; anchors.rightMargin: marginsize;
                text: qsTr("Log:\n")
            }
        }

    }

    FileDialog {
        id: fileDialog
        title: "Please choose a folder"
        folder: shortcuts.home;
        selectFolder: true; selectMultiple: false;
        onAccepted: {
            var path = fileDialog.folder.toString();
            // remove prefixed "file:///"
            path = path.replace(/^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,"");
            // unescape html codes like '%23' for '#'
            save_as_file.text = decodeURIComponent(path)+"/";
        }
        onRejected: {
            console.log("Canceled")
        }
        Component.onCompleted: visible = false
    }

    Connections {
        target: XReaderContext;
        ignoreUnknownSignals: true;
        onSignal_test: {
            console.log(number);
        }
    }

    Connections {
        target: ProcessLauncher;
        ignoreUnknownSignals: true;
        onSig_stdHasData: {
            logger.text += data;
        }
    }

    function startDownloadWork(app, argv) {
        XReaderContext.slot_run(app, argv);
    }

}
