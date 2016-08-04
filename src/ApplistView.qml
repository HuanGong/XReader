import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import "js/Utils.js" as Utils

Item {
    signal sigCloseApplistView();
    signal sigOpenApplication(var app_name, var url);

    property real dpi: Screen.pixelDensity.toFixed(2)

    id: applist
    anchors.fill: parent

    PropertyAnimation { target: applist; property: "opacity";
        duration: 800; from: 0; to: 1;
        easing.type: Easing.InOutQuad ; running: true
    }
    Rectangle {
        anchors.fill: parent
        id: overlay;
        color: "#000000"; opacity: 0.6
        MouseArea {
            anchors.fill: parent
            onWheel: {}
            onClicked: {
                console.log("overlay be clicked")
                applist.destroy();
            }
        }
    }

    // This rectangle is the actual applistview
    Rectangle {
        id: app_contaner;

        radius: Utils.gu(8);
        anchors.fill: parent
        anchors.leftMargin: Utils.gu(128); anchors.rightMargin: Utils.gu(128);
        anchors.topMargin: Utils.gu(96); anchors.bottomMargin: Utils.gu(72)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent; onClicked: {console.log("pos 3 be clicked")
        }}

        Text {
            id: tag_title
            text: qsTr("Application List")
            font.bold: true; font.pointSize: Utils.gu(13);
            anchors.top: parent.top; anchors.topMargin: Utils.gu(24)
            anchors.left: parent.left; anchors.leftMargin: (parent.width-width)/2
        }

        GridView {
            id: grid_view; focus: true;
            cellWidth: width/4; cellHeight: cellWidth
            anchors.top: tag_title.bottom; anchors.topMargin: Utils.gu(24);
            anchors.left: parent.left; anchors.leftMargin: Utils.gu(32);
            anchors.right: parent.right; anchors.rightMargin: Utils.gu(32);
            Layout.fillHeight: true; Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            highlightFollowsCurrentItem: true

            model: ListModel {
                id: app_list;
                ListElement { name: "Bing 壁纸"; Appurl: "qrc:/src/snack/XExplorer.qml"; image: "qrc:/image/icon/app-gallery.svg"}
                ListElement { name: "二维码工具"; Appurl: "qrc:/src/snack/QRToolsView.qml"; image: "qrc:/image/icon/app-qrtools.png"}
                ListElement { name: "youtubedl"; Appurl: "qrc:/src/snack/youtubedl.qml"; image: "qrc:/image/icon/app-youtubedl.svg"}
            }
            delegate: Item {
                id: app_item
                width: grid_view.cellWidth
                height: grid_view.cellHeight
                Image {
                    id: app_icon
                    width: grid_view.cellWidth*12/16; height: width;
                    anchors.top: parent.top; anchors.topMargin: width*1/16;
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: image
                }
                Text {
                    id: app_name
                    elide: Text.ElideRight;
                    wrapMode: Text.WordWrap;
                    horizontalAlignment: Text.AlignHCenter;
                    verticalAlignment: Text.AlignVCenter;
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: app_icon.bottom; anchors.topMargin: 0
                    font.pointSize: Utils.gu(13);
                    text: name
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                    onClicked: {
                        if (grid_view.currentIndex === index) {
                            sigOpenApplication(name, Appurl);
                            applist.destroy();
                        } else {
                            grid_view.currentIndex = index;
                        }
                    }
                }
            }

            highlight: highlight
            Component {id: highlight;Rectangle{color: "#f69331"; radius: 8}}
        }

    }

    Component.onCompleted: {
        console.log("addnew feed dlg component loaded")
    }
    Component.onDestruction: {
        console.log("applist view going to die, feel free")
    }
}
