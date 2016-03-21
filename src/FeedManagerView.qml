import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2

Item {
    property var dlgobj: null
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
                anchors.centerIn: parent
                text: "Add Feed"
                onClicked: {
                    console.log("add a new feed to GridView")
                    //Qt.createComponent("AddNewFeedDialog.qml").createObject(feedManagerView, {});
                    sigShowAddFeedView(null);
                    //addNewFeed();

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
                ListElement {
                    name: "Oschina"
                    feed: "http://www.oschina.net/news/rss?show=industry"
                    colorCode: "#218868"
                }
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
                        text: "Title:" + model.name
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
                x: grid_chanel_view.currentItem.x - grid_chanel_view.contentX
                y: grid_chanel_view.currentItem.y - grid_chanel_view.contentY
                width: 16; height: 16
                color: "lightblue"
                visible: false
                MouseArea {
                    id: delete_mousearea
                    anchors.fill: delete_feed
                    onClicked: {
                        console.log("i will remove the item and set myselt invisible")
                        grid_chanel_view.model.remove(grid_chanel_view.currentItem)
                        delete_feed.visible = false
                    }
                }
            }
            onCurrentItemChanged: {
                console.log("Ha!, onCurrentItemChanged, current:")
                console.log(currentItem)
            }

            onCurrentIndexChanged: {
                console.log(currentIndex )
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

    function onAddNewFeed(url, name) {
        console.log("onAddNewFeed be trigged", url, name)
        grid_chanel_view.model.insert();
        feed_data.insert(feed_data.count, {"name": name, "feed": url, "colorCode": "#218868"})

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
    }
}
