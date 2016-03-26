import QtQuick 2.0

Item {
    objectName: "XExploerer"
    id: x_explorer
    anchors.fill: parent
    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#E3EDCD"


    }
    Component.onCompleted: {
        console.log("\n=======XExplorer loaded========\n")
    }
}
