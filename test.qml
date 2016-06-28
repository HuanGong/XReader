import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1

Window {
    width: 600
    height: 400
    visible: true

    Component {
        id: listDelegate
        Rectangle {
            height: 30
            width: parent.width
            color:  ListView.isCurrentItem ? "orange" : "white"
            property var view: ListView.view
            property int itemIndex: index
            Text { anchors.centerIn: parent; text: name }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = itemIndex;
                }
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        ListView {
            Layout.minimumWidth: parent.width / 2
            Layout.fillHeight: true
            model: ListModel {
                ListElement {name: "item1.1"}
                ListElement {name: "item1.2"}
                ListElement {name: "item1.3"}
            }
            delegate: listDelegate
        }
        ListView {
            id: aaaa
            Layout.minimumWidth: parent.width / 2
            Layout.fillHeight: true
            model: ListModel {
                ListElement {name: "item2.1"}
                ListElement {name: "item2.2"}
                ListElement {name: "item2.3"}
            }
            delegate: listDelegate;
            NumberAnimation {
              target: aaaa
              property: "opacity"
              to: 1  /* When the delegate is added to the view, */
                 /* the scale will be animated to 1 */
              duration: 3000
              easing.type: Easing.InOutQuad
          }
      }
  }

  Rectangle {
    id: a1; opacity: 0.8;
    color: "red"; z: 2
    width: 200; height: 200;
            NumberAnimation {
              target: a1
              property: "opacity"
              to: 0  /* When the delegate is added to the view, */
                     /* the scale will be animated to 1 */
              duration: 3000
              easing.type: Easing.InOutQuad
          }
          NumberAnimation on opacity {
             id: createAnimation
             easing.type: Easing.InOutQuad
             to: 1
             duration: 2000
          }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (opacity < 1)
          a1.opacity = 1;
        else
          a1.opacity = 0;
        //createAnimation.start();
      }
    }
  }
}
