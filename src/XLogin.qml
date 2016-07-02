import QtQuick 2.0
import "js/Utils.js" as Utils

Flipable {
    id: container

    property alias source: frontImage.source
    property bool flipped: true
    property int xAxis: 0
    property int yAxis: 1
    property int angle: 180

    width: 430; height: 330;
    anchors.centerIn: parent;

    back: Image {
        id: frontImage;
        anchors.centerIn: parent;
        source: "qrc:/image/resource/icon/QQloginFront.jpg"
    }
    front: Rectangle {
        width: 430; height: 330;
        anchors.centerIn: parent;
        color: "gray";
        Text {
            anchors.centerIn: parent
            text: qsTr("Loging Proxy Setting Page")
        }
    }

    state: "front"

    MouseArea { anchors.fill: parent; onClicked: container.flipped = !container.flipped }

    transform: Rotation {
        id: rotation; origin.x: container.width / 2; origin.y: container.height / 2
        axis.x: container.xAxis; axis.y: container.yAxis; axis.z: 0
    }

    states: State {
        name: "front"; when: container.flipped
        PropertyChanges { target: rotation; angle: container.angle }
    }

    transitions: Transition {
        ParallelAnimation {
            NumberAnimation { target: rotation; properties: "angle"; duration: 700 }
            SequentialAnimation {
                NumberAnimation { target: container; property: "scale"; to: 0.65; duration: 350 }
                NumberAnimation { target: container; property: "scale"; to: 1.0; duration: 350 }
            }
        }
    }
}
