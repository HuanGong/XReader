import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import "HttpRequest.js" as HttpOpt
import "feedstorage.js" as FeedsDb

Item {
    signal sigChanelSelected(var model_instance)
    signal sigShowAddFeedView(var arg1)

    id: feedManagerView
    anchors.fill: parent
    ColumnLayout {
        id: columnLayout1
        anchors.fill: parent

        Rectangle {
            id: xreader_title
            z: 2
            height: 64
            color: "#f69331"
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Button {
                id: bt_add_new_feed
                anchors.left: parent.left; anchors.leftMargin: 10
                text: "Add Feed"
                onClicked: {
                    sigShowAddFeedView(null);
                }
            }

            Button {
                id: bt_http_request
                anchors.left: bt_add_new_feed.right; anchors.leftMargin: 10
                text: "GET"
                onClicked: {
                    var url = "http://image.baidu.com/data/imgs?col=宠物&tag=狗&sort=0&pn=1&rn=1&p=channel&from=1";
                    HttpOpt.get(url, getOk, getFailed)
                }
                function getOk(result, json) {
                    console.log(result, json)
                    var img = JSON.parse(result).imgs[0].imageUrl
                    post_img.source = img
                }
                function getFailed(responseText, status) {
                   console.log(responseText, status)
                }
            }
        }

        GridView {
            id: grid_chanel_view
            z: 1
            cellHeight: 64
            cellWidth: grid_chanel_view.width / 3
            displayMarginBeginning: 0
            displayMarginEnd: 6
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            highlightFollowsCurrentItem: false
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
                    opacity: 0.85
                    color: colorCode
                    anchors.fill: parent
                    anchors.topMargin: 4
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    anchors.bottomMargin: 4

                    Text {
                        id: feed_title
                        width: parent.width - 4
                        elide: Text.ElideRight
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 4
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
                    width: grid_chanel_view.cellWidth; height: grid_chanel_view.cellHeight
                    color: "#f69331"; radius: 5
                    x: grid_chanel_view.currentItem.x
                    y: grid_chanel_view.currentItem.y
                    Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
                    Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }

                }
            }


            Component.onCompleted: {
                if (feed_data.count == 0) {

                } else {

                }
            }
        }
    }

    Rectangle {
        radius: 12
        width: 24
        height: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        color: "pink"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                grid_chanel_view.contentX = 0
                grid_chanel_view.contentY = 0
                grid_chanel_view.currentIndex = 0
            }
        }
    }

    Image {
        id: post_img
        z: 2
        width: 200
        height: 200
        visible: true
        anchors.centerIn: parent
        source: ""
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
        FeedsDb.initDatabase();
        FeedsDb.readData();
    }

    Component.onDestruction: {
        //print("it is going to save data");
        //DB.storeData();
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
