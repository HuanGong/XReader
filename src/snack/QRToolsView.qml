import QZXing 2.3


import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1


Item {
    property real dpi: Screen.pixelDensity.toFixed(2)

    anchors.fill: parent

    Rectangle {
        id: title
        height: dpi*16
        anchors.top: parent.top; anchors.topMargin: 0;
        anchors.left: parent.left;anchors.right:parent.right
        color: "pink"
        Rectangle {
            id: bt_decoder_qr;
            color: "orange"; radius: 2*dpi;
            width: title.width/2 - 2*dpi;
            anchors.left: parent.left; anchors.leftMargin: dpi;
            anchors.top: parent.top; anchors.topMargin: dpi;
            anchors.bottom: parent.bottom; anchors.bottomMargin: dpi;
            Text {
                anchors.centerIn: parent;
                font.pointSize: 6*dpi;
                text: qsTr("解          码")
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    bt_decoder_qr.focus = true;
                    loader.sourceComponent = qr_decoder;
                }
            }
            onFocusChanged: {
                color = focus ? "orange" : "green";
            }
        }
        Rectangle {
            id: bt_encoder_qr;
            color: "green"; radius: 2*dpi;
            width: title.width/2 - 2*dpi;
            anchors.right: parent.right; anchors.rightMargin: dpi;
            anchors.top: parent.top; anchors.topMargin: dpi;
            anchors.bottom: parent.bottom; anchors.bottomMargin: dpi;
            Text {
                anchors.centerIn: parent;
                font.pointSize: 6*dpi;
                text: qsTr("编          码")
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    bt_encoder_qr.focus = true;
                    loader.sourceComponent = qr_generator;
                }
            }
            onFocusChanged: {
                color = focus ? "orange" : "green";
            }
        }
    }


    Loader {
        id: loader
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.top: title.bottom; anchors.bottom: parent.bottom;
        sourceComponent: qr_decoder
    }

    Component {
        id: qr_decoder;
        Rectangle {
            id: qr_decoder_view
            anchors.fill: parent
            anchors.bottomMargin: 6*dpi; anchors.topMargin: 6*dpi;
            anchors.leftMargin: 6*dpi; anchors.rightMargin: 6*dpi;
            radius: 12; color: "lightgray"
            Image {
                id: qr_code;
                anchors.fill: parent;
                fillMode: Image.PreserveAspectFit;
                anchors {
                    topMargin: 2 * dpi; leftMargin: 2 * dpi;
                    rightMargin: 2 * dpi; bottomMargin: 2 * dpi;
                }
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
                font.pointSize: dpi*8;
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
            anchors.fill: parent;
            color: "lightgray"

            Rectangle {
                id:input_area
                radius: 4
                height: 12 *dpi
                width: parent.width
                color: "#f69331"

                Item {
                    id: tag_hint
                    height: parent.height
                    width: info.contentWidth;
                    anchors.left: parent.left; anchors.leftMargin: dpi
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: info
                        height: parent.height
                        text: qsTr("Infomation:")
                        anchors.centerIn: parent
                        font.pointSize: 5*dpi
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Rectangle {
                    id: textInputContainer
                    radius: 2*dpi
                    anchors.left: tag_hint.right; anchors.right: parent.right;
                    anchors.top: parent.top; anchors.bottom: parent.bottom;
                    anchors.topMargin: dpi; anchors.bottomMargin: dpi;
                    anchors.rightMargin: dpi; anchors.leftMargin: dpi
                    TextInput {
                        id: inputField
                        clip: true;
                        opacity: 0.6;
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        anchors.rightMargin: dpi; anchors.leftMargin: dpi
                        text: qsTr("")
                        font.bold: true
                        font.pointSize: 4*dpi;
                        //cursorVisible: false
                        onFocusChanged: {
                            if (focus == true) {
                                opacity = 1;
                            } else {
                                opacity = 0.5;
                            }
                        }
                        onTextChanged: {

                        }

                        Text {
                            id: hint;
                            //opacity: 0.5;
                            anchors.centerIn: parent
                            font.pointSize: 4*dpi;
                            verticalAlignment: Text.AlignVCenter
                            visible: !parent.focus
                            text: qsTr("Input Something Here");
                        }
                    }
                }
            }

            Rectangle {
                id: code_area
                anchors.top: input_area.bottom; anchors.bottom: parent.bottom
                anchors.horizontalCenter : parent.horizontalCenter
                radius: 2*dpi; color: "lightgreen"
                QRCode {
                    id: qr_canvas
                    width : 168
                    height : width
                    anchors.centerIn: parent;
                    value : inputField.text;
                    level : "H"
                    MouseArea{
                        anchors.fill: parent
                        onWheel: {
                            console.log(wheel.pixelDelta)
                            if (wheel.pixelDelta.y > 0 && qr_canvas.width > 168) {
                                qr_canvas.width -= 21;
                            } else if (wheel.pixelDelta.y < 0 && qr_canvas.width < code_area.height) {
                                qr_canvas.width += 21;
                            }
                        }
                    }
                }
            }

            Image {
                id: save_bt
                width: 8*dpi; height: width;
                anchors.bottom: parent.bottom; anchors.bottomMargin: 4*dpi;
                anchors.right: parent.right; anchors.rightMargin: 4*dpi;
                rotation: 180;
                source: "qrc:/image/icon/go-top.png"
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        qr_canvas.save("gonghuan.png");
                    }
                }
            }

        }
    }

}
