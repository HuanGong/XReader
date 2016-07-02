
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0

import "../js/HttpRequest.js" as HttpOpt

Item {
    objectName: "XExploerer"
    id: x_explorer; clip: true
    GridView {
        id: grid_view
        cellWidth: width/3
        cellHeight: cellWidth * 0.618
        anchors.fill: parent
        anchors.leftMargin: 12; anchors.rightMargin: 12
        anchors.topMargin: 42; anchors.bottomMargin: 12

        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        highlightFollowsCurrentItem: true
        focus: true

        model: ListModel {
            id: img_data
        }
        delegate: Item {
            id: chanel_delegate
            width: grid_view.cellWidth; height: grid_view.cellHeight
            Rectangle {
                radius: 12; color: "green";
                anchors.fill: parent; clip: true;
                anchors.topMargin: 16; anchors.leftMargin: 16
                anchors.rightMargin: 16; anchors.bottomMargin: 16
                Image {
                    id: post_img
                    clip: true;
                    anchors.fill: parent
                    source: imgurl
                    MouseArea {
                        id: mousearea_feed
                        anchors.fill: parent
                        onClicked: {
                            if (grid_view.currentIndex === index) {
                                //show big image
                                detail_loader.sourceComponent = detail;
                                detail_loader.item.setImgUrl(imgurl);
                                detail_loader.item.sigDoubleClicked.connect(onDetailDCliced);
                            } else {
                                grid_view.currentIndex = index
                            }
                        }
                    }
                    BusyIndicator {
                        id: busyindicator; anchors.centerIn: parent
                        running: post_img.status === Image.Loading
                    }
                    Timer {
                        id: timer; repeat: false;
                        interval: 12000;
                        onTriggered: {busyindicator.running = false;}
                    }
                    Component.onCompleted: {
                        timer.running = true;
                    }
                }
            }
        }

        highlight: highlight
        Component {
            id: highlight
            Rectangle {
                id: focused_feed_bg
                color: "#f69331"; radius: 5
            }
        }
    }

    Component.onCompleted: {
        var url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=12&mkt=zh-CN";
        HttpOpt.get(url, getOk, getFailed)
    }

    Loader {
        id: detail_loader
        anchors.fill: parent
    }

    Component {
        id: detail
        Item {
            signal sigDoubleClicked();
            signal sigDownloadClicked();

            id: detail_view
            anchors.fill: parent

            PropertyAnimation { target: detail_view; property: "opacity";
                duration: 800; from: 0; to: 1;
                easing.type: Easing.InOutQuad ; running: true
            }
            Rectangle {
                id: overlay
                anchors.fill: parent
                color: "#000000"; opacity: 0.45
                MouseArea { anchors.fill: parent;
                    onWheel: {}
                    onClicked: {
                        sigDoubleClicked();
                    }
                }
            }

            Image {
                id: detail_img
                property int margin: 32
                anchors.centerIn: parent;
                width: parent.width*0.9; height: width*0.618
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("haha")
                    }
                    onWheel: {
                        console.log(wheel.pixelDelta)
                        if (wheel.pixelDelta.y > 0) {
                            detail_img.width -= 10
                        } else if (wheel.pixelDelta.y < 0) {
                            detail_img.width += 10
                        }
                    }

                    onDoubleClicked: {
                        console.log("double clicked")
                        sigDoubleClicked();
                    }
                }
            }
            Component.onDestruction:  {
                console.log("hahah destroyed")
            }

            function setImgUrl(url) {
                console.log(url)
                detail_img.source = url
            }
        }
    }

    function onDetailDCliced() {
        console.log("on detail double clicked")
        detail_loader.sourceComponent = undefined;
    }

    function getOk(result, json) {
        var images = json.images;
        for (var index in images) {
            var new_data = {"id": index, "imgurl": images[index].url};
            img_data.append(new_data)
        }
    }
    function getFailed(responseText, status) {
        console.log(responseText, status)
    }

}

