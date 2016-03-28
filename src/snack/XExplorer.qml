import QtQuick 2.0
import "qrc:/src/HttpRequest.js" as HttpOpt


Item {
    objectName: "XExploerer"
    id: x_explorer
    clip: true
    anchors.fill: parent
    Rectangle {
        id: bg
        clip: true
        color: "#E3EDCD"
        anchors.fill: parent

        Image {
            id: post_img
            anchors.centerIn: parent
            source: ""
        }

    }
    Component.onCompleted: {
        console.log("\n=======XExplorer loaded========\n")
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
