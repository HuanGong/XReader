import QtQuick 2.0

Rectangle{
    id: main
    //width: 680; height:800
    anchors.fill: parent
    radius: 12;// color: "red";
    Row {
        spacing: 10;
        anchors.centerIn: parent
        Rectangle {
            radius: 8; clip: true;
            width: 400; height: 760;
            color: "pink"
            Image {
                id: left; clip: true;
                anchors.fill: parent
                source: "./left.png"
            }
        }
        Rectangle {
            radius: 8; clip: true;
            width: 400; height: 760;
            color: "blue"
            Image {
                id: right; clip: true;
                anchors.fill: parent
                source: "./right.png"
            }
        }
    }
}
