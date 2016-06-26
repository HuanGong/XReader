import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4

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

        radius: 8;
        anchors.fill: parent
        anchors.leftMargin: 128; anchors.rightMargin: 128;
        anchors.topMargin: 96; anchors.bottomMargin: 72
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent; onClicked: {console.log("pos 3 be clicked")
        }}

        Text {
            id: tag_title
            text: qsTr("Application List")
            font.bold: true; font.pointSize: 18;
            anchors.top: parent.top; anchors.topMargin: 24
            anchors.left: parent.left; anchors.leftMargin: (parent.width-width)/2
        }

        GridView {
            id: grid_view; focus: true;
            cellWidth: width/4; cellHeight: cellWidth
            anchors.top: tag_title.bottom; anchors.topMargin: 24;
            anchors.left: parent.left; anchors.leftMargin: 32;
            anchors.right: parent.right; anchors.rightMargin: 32;
            Layout.fillHeight: true; Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            highlightFollowsCurrentItem: true

            model: ListModel {
                id: app_list;
                ListElement { name: "Bing 壁纸"; Appurl: "qrc:/src/snack/XExplorer.qml"; image: "qrc:/image/icon/app-gallery.svg"}
                ListElement { name: "二维码工具"; Appurl: "qrc:/src/snack/QRToolsView.qml"; image: "qrc:/image/icon/app-qrtools.png"}
                ListElement { name: "youtubedl"; Appurl: "qrc:/src/snack/QRToolsView.qml"; image: "qrc:/image/icon/app-youtubedl.svg"}
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
                    font.pointSize: grid_view.cellWidth*2/16;
                    text: name
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                    onClicked: {
                        console.log("fuck delegate item be clicked")
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

/*
Item {
    BorderImage {
        id:applistBox
        x: 12; y: 42
        property alias contectText: contentTextId.text

        border { left: 32; top: 12; right: 4; bottom: 4 }
        source: "qrc:/image/icon/bubble.png"

        Rectangle {
            id: shade;
            color: "green"
            anchors.fill: parent
            anchors.topMargin: 16; anchors.bottomMargin: 4;
            anchors.leftMargin: 4; anchors.rightMargin: 4;
            radius: 8;
            opacity: 1;//定义了透明度,0为完全透明,1为完全不透明* /

            Text{
                id:contentTextId
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text:"message"
                font.pointSize: 10
            }
        }
    }

}
*/
