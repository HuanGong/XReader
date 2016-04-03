import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import "feedstorage.js" as FeedsDb

Item {
    signal sigChanelSelected(var model_instance)
    signal sigShowAddFeedView(var arg1)

    id: feedManagerView

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            id: xreader_title
            z: 2;height: 48
            color: "#f69331"
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter //| Qt.AlignTop
            Button {
                id: bt_add_feed
                anchors.centerIn: parent
                text: "Add Feed"
                onClicked: {
                    sigShowAddFeedView(null);
                }
            }
        }

        GridView {
            id: grid_chanel_view
            cellHeight: 64
            cellWidth: grid_chanel_view.width / 3
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            highlightFollowsCurrentItem: true
            focus: true

            model: ListModel {
                id: feed_data
            }
            delegate: Item {
                id: chanel_delegate
                width: grid_chanel_view.cellWidth
                height: grid_chanel_view.cellHeight
                Rectangle {
                    id: bg
                    radius: 4
                    opacity: 0.8
                    color: colorCode
                    anchors.fill: parent
                    anchors.topMargin: 4
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    anchors.bottomMargin: 4

                    Text {
                        id: feed_title
                        //width: parent.width - 4
                        elide: Text.ElideRight
                        //anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom; anchors.bottomMargin: 4
                        font.pointSize: 12
                        text: model.name
                        onTextChanged: {
                            console.log("some case cause the text changed:",text)
                        }
                    }
                    MouseArea {
                        id: mousearea_feed
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton | Qt.LeftButton
                        onClicked: {
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

            Rectangle {
                id: delete_feed
                radius: 8
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
                width: 16; height: 16
                color: "lightblue"
                visible: false
                MouseArea {
                    id: delete_mousearea
                    anchors.fill: delete_feed
                    onClicked: {
                        removeItemFromFM();
                    }
                }
            }

            highlight: highlight
            Component {
                id: highlight
                Rectangle {
                    id: focused_feed_bg
                    //width: grid_chanel_view.cellWidth; height: grid_chanel_view.cellHeight
                    color: "#f69331"; radius: 5
                    //x: grid_chanel_view.currentItem.x
                    //y: grid_chanel_view.currentItem.y
                    //Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
                    //Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }

                }
            }


            Component.onCompleted: {
                if (feed_data.count == 0) {

                } else {

                }
            }
        }
    }

    Item {
        width: 24
        height: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 64
        anchors.right: parent.right
        anchors.rightMargin: 12
        Image {
            id: img_go_top
            anchors.fill: parent
            //clip: true
            visible: true
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
        //FeedsDb.removeData(datatoberemove)
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


/*
var component = Qt.createComponent("AddNewFeedDialog.qml");
var incubator = component.incubateObject(feedManagerView, {});

if (incubator.status !== Component.Ready) {
    incubator.onStatusChanged = function(status) {
        if (status === Component.Ready) {
            print ("Object", incubator.object, "is now ready!");
        }
    }
} else {
    print ("Object", incubator.object, "is ready immediately!");
}
*/
