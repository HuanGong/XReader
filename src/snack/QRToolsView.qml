import QZXing 2.3

import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import "../js/Utils.js" as Utils


Item {
    property real dpi: Screen.pixelDensity.toFixed(2)

    anchors.fill: parent

    Row {
        id: title
        height: Utils.gu(32); spacing: Utils.gu(10)
        anchors.top: parent.top; anchors.topMargin: Utils.gu(4);
        anchors.left: parent.left;anchors.right:parent.right
        anchors.leftMargin: Utils.gu(4); anchors.rightMargin: Utils.gu(4)
        Rectangle {
            id: bt_decoder_qr;
            color: container.flipped ? "orange" : "green"; radius: Utils.gu(2);
            width: (title.width-title.spacing)/2; height: Utils.gu(32)
            Text {
                anchors.centerIn: parent;
                font.pointSize: Utils.gu(13);
                text: qsTr("解          码")
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    container.flipped = true;
                }
            }
        }
        Rectangle {
            id: bt_encoder_qr;
            color: container.flipped ? "green" : "orange"; radius: Utils.gu(2);
            width: (title.width-title.spacing)/2; height: Utils.gu(32)
            Text {
                anchors.centerIn: parent;
                font.pointSize: Utils.gu(13);
                text: qsTr("编          码")
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    container.flipped = false;
                }
            }
        }
    }

    Flipable {
        id: container

        property bool flipped: true
        property int xAxis: 0
        property int yAxis: 1
        property int angle: 180

        anchors.left: parent.left; anchors.right: parent.right;
        anchors.top: title.bottom; anchors.bottom: parent.bottom;
        anchors.margins: Utils.gu(2)

        back: qr_decoder.createObject(container, {});
        front: qr_generator.createObject(container, {});

        state: "front"

        //MouseArea { anchors.fill: parent; onClicked: container.flipped = !container.flipped }

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

    Component {
        id: qr_decoder;
        Rectangle {
            id: qr_decoder_view
            anchors { fill: parent; margins: Utils.gu(6) }
            radius: 12; color: "lightgray"; clip: true
            Image {
                id: qr_code; clip: true
                anchors.centerIn: parent; width: Utils.gu(128); height: width
                fillMode: Image.PreserveAspectFit;
            }
            DropArea {
                anchors.fill: parent;
                onDropped: {
                    if (drop.hasUrls) {
                        var reg = /[^\s]+\.(jpg|gif|png|bmp|BMP|PNG|GIF|JPG)$/;
                        if (reg.test(drop.urls[0])) {
                            drop.accept();
                            qr_code.source = drop.urls[0];
                            decoder.decodeImageFromFile(drop.urls[0]);
                        }
                    }
                }
            }

            Text {
                id: tips; opacity: 0.6;
                font.pointSize: Utils.gu(13);
                visible: {return qr_code.status == Image.Null}
                anchors.centerIn: parent;
                text: qsTr("Drag Image Here")
            }

            QZXing {
                id:decoder
                enabledDecoders: QZXing.DecoderFormat_None; //QZXing.DecoderFormat_QR_CODE
                onDecodingStarted: {
                    console.log("QZXing decode start!")
                }
                onDecodingFinished: {}
                onError: {
                    messageDialog.icon = StandardIcon.Critical;
                    messageDialog.show(msg);
                    qr_code.source = "";
                }
                onTagFound: {
                    messageDialog.icon = StandardIcon.NoIcon;
                    messageDialog.show(tag);
                }
            }

            MessageDialog {
                id: messageDialog
                function show(caption) {
                    messageDialog.text = caption;
                    messageDialog.open();
                }
            }

        }
    }

    Component {
        id: qr_generator;
        Rectangle {
            id: qr_Generator_view
            anchors { fill: parent; margins: Utils.gu(6) }
            color: "white"; radius: 12;

            Rectangle {
                id:input_area
                radius: 4; color: "#f69331"
                height: Utils.gu(32); width: parent.width
                Item {
                    id: tag_hint
                    height: parent.height; width: info.contentWidth;
                    anchors.left: parent.left; anchors.leftMargin: Utils.gu(2)
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: info
                        height: parent.height
                        text: qsTr("Infomation:")
                        anchors.centerIn: parent
                        font.pointSize: Utils.gu(12);
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Rectangle {
                    id: textInputContainer
                    radius: Utils.gu(2)
                    anchors {
                        left: tag_hint.right; right: parent.right;
                        top: parent.top; bottom: parent.bottom;
                        margins: Utils.gu(1);
                    }
                    TextInput {
                        id: inputField
                        clip: true; opacity: 0.6;
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        anchors.rightMargin: Utils.gu(2);
                        anchors.leftMargin: Utils.gu(2)
                        text: qsTr("")
                        font.bold: true; font.pointSize: Utils.gu(10);
                        cursorVisible: false
                        onFocusChanged: {
                            opacity = focus ? 1 : 0.5;
                        }
                        Text {
                            id: hint;
                            anchors.centerIn: parent
                            font.pointSize: Utils.gu(10);
                            verticalAlignment: Text.AlignVCenter
                            visible: !parent.focus
                            text: qsTr("Input Something Here");
                        }
                    }
                }
            }

            Item {
                id: code_area
                anchors.top: input_area.bottom; anchors.bottom: parent.bottom
                anchors.horizontalCenter : parent.horizontalCenter
                QRCode {
                    id: qr_canvas;
                    width : 168; height : width
                    anchors.centerIn: parent;
                    value : inputField.text;
                    level : "M"; background: "white"
                    MouseArea{
                        anchors.fill: parent
                        onWheel: {
                            console.log(wheel.pixelDelta)
                            if (wheel.pixelDelta.y > 0 && qr_canvas.width > 168) {
                                qr_canvas.width -= 21;
                                qr_canvas.height = qr_canvas.width;
                            } else if (wheel.pixelDelta.y < 0 &&
                                       qr_canvas.width < code_area.height) {
                                qr_canvas.width += 21;
                                qr_canvas.height = qr_canvas.width;
                            }
                        }
                    }
                }
            }

            Image {
                id: save_bt
                width: Utils.gu(24); height: width;
                anchors.bottom: parent.bottom; anchors.bottomMargin: Utils.gu(12);
                anchors.right: parent.right; anchors.rightMargin: Utils.gu(12);
                rotation: 180; source: "qrc:/image/icon/go-top.png"
                MouseArea {
                    anchors.fill: parent;
                    onClicked: { save_dialog.open() }
                }
            }
            FileDialog {
                id: save_dialog
                title: "Please choose a folder to save the QRCODE"
                folder: shortcuts.home;
                //nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
                selectFolder: true;
                selectMultiple: false;
                onAccepted: {
                    var save_urls = folder.toLocaleString().substring(7) + "/qrcode_";
                    save_urls += Math.random().toString(36).substr(2,6) + ".png";
                    console.log(save_urls)
                    qr_canvas.save(save_urls);
                }
                onRejected: {
                    console.log("Canceled")
                }
                Component.onCompleted: visible = false
            }
        }
    }

}
