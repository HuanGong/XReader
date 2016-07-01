import QtQuick 2.4
import QtQuick.Window 2.2

import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import "js/feedstorage.js" as FeedsDb

import "js/Utils.js" as Utils

Item {
    signal sigChanelSelected(var model_instance)
    signal sigShowAddFeedView(var arg1)
    property real dpi: Screen.pixelDensity.toFixed(2)/2; //Screen.pixelDensity;

    id: feedManagerView

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            id: xreader_title
            z: 2; height: 48; color: "#f69331"
            Layout.fillHeight: false; Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter //| Qt.AlignTop
            Image {
                id: bt_add_feed
                width: 32; height: 32;
                anchors.centerIn: parent;
                source: "qrc:/image/icon/edit-add.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sigShowAddFeedView(null);
                    }
                }
            }
        }

        GridView {
            id: grid_chanel_view
            cellHeight: cellWidth/2; cellWidth: width / 3
            Layout.fillHeight: true; Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            highlightFollowsCurrentItem: true; focus: true

            model: ListModel {
                id: feed_data
            }
            delegate: delegate_component

            Rectangle {
                id: delete_feed; radius: 8; color: "#f69331"
                width: 16; height: 16; visible: false
                x: { if(grid_chanel_view.currentItem !== null)
                        grid_chanel_view.currentItem.x - grid_chanel_view.contentX;
                    else
                        0;
                }
                y: { if(grid_chanel_view.currentItem !== null)
                        grid_chanel_view.currentItem.y - grid_chanel_view.contentY;
                     else
                        0;
                }
                Image {
                    anchors.fill: parent
                    source: "qrc:/image/icon/edit-clear.svg"
                }
                MouseArea {
                    id: delete_mousearea
                    anchors.fill: delete_feed
                    onClicked: {
                        removeItemFromFM();
                    }
                }
            }
        }
    }


    Image {
        id: img_go_top
        width: 24; height: 24
        anchors.bottom: parent.bottom; anchors.bottomMargin: 32
        anchors.right: parent.right; anchors.rightMargin: 12

        source: "qrc:/image/icon/go-top.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                grid_chanel_view.contentX = 0
                grid_chanel_view.contentY = 0
                grid_chanel_view.currentIndex = 0
            }
        }
    }


    Component {
        id: delegate_component
        Item {
            id: chanel_delegate; clip: true;
            property var grid_view: GridView.view
            property var is_currentItem: GridView.isCurrentItem
            width: grid_view.cellWidth; height: grid_view.cellHeight;
            visible: {grid_view.width > 128;}
            Rectangle {
                radius: 4; opacity: 0.8; anchors.fill: parent
                anchors.topMargin: 2; anchors.leftMargin: 2
                anchors.rightMargin: 2; anchors.bottomMargin: 4
                color: is_currentItem ? colorCode : "lightgray";
                clip: true;
                Text {
                    elide: Text.ElideRight
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 4
                    font.pointSize: XReaderContext.gu();
                    text: model.name
                }

                MouseArea {
                    id: mousearea_feed
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                    onClicked: {
                        XReaderContext.gu(10);
                        if (delete_feed.visible === true &&
                                mouse.button === Qt.LeftButton) {
                            delete_feed.visible = (false)
                            return
                        }
                        if (mouse.button === Qt.LeftButton) {
                            if (grid_chanel_view.currentIndex != index) {
                                grid_chanel_view.currentIndex = index
                            } else {
                                feedManagerView.visible = false
                                console.log(model.name, model.feed)
                                sigChanelSelected(model)
                            }
                        }
                    }
                    onReleased: {
                        if (grid_chanel_view.currentIndex != index)
                            return
                        if (mouse.button === Qt.RightButton) {
                            console.log("I will change the visibility to:" ,index)
                            delete_feed.visible = delete_feed.visible ? false : true
                        }

                    }
                }
            }
        }
    }

    // a callback from AddNewFeedView
    function onAddNewFeed(url, name) {
        var new_data = {"name": name, "feed": url, "colorCode": "#218868"};
        FeedsDb.insertData(new_data)
        feed_data.insert(feed_data.count, new_data)
    }

    // remove data from model and database
    function removeItemFromFM() {
        console.log("1 current item index is:", grid_chanel_view.currentIndex)
        var data = feed_data.get(grid_chanel_view.currentIndex);
        if (data === undefined) {
            console.log("data is not find。。。。。")
            return;
        }

        var datatoberemove = {"name": data.name, "feed": data.feed};
        console.log(JSON.stringify(datatoberemove))
        console.log("2 current item index is:", grid_chanel_view.currentIndex)
        feed_data.remove(grid_chanel_view.currentIndex)
        FeedsDb.removeData(datatoberemove)
        delete_feed.visible = false
    }

    Component.onCompleted: {
        console.log("=======FeedsManager view is created!")
        FeedsDb.initDatabase();
        FeedsDb.readData();
    }

    Component.onDestruction: {
        console.log("=======FeedsManager is going to die!")
    }
}
