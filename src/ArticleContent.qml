import QtQuick 2.0
import QtQuick.Controls 1.4
//import Qt.labs.controls 1.0
//import Ubuntu.Components 1.1

Item {
   id: article_content
   property alias text: content.text

   Flickable {
       id: flickableContent
       anchors.fill: parent

       Text {
           id: content
           text: "sample text"
           textFormat: Text.RichText
           wrapMode: Text.WordWrap
           width: parent.width
       }

       contentWidth: parent.width
       contentHeight: content.height
       clip: true
   }

   Button {
       id: back_bt
       anchors.centerIn: parent
       text: "back"
   }

/*
   Scrollbar {
       flickableItem: flickableContent
   }*/
}
