import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Dialog {
    standardButtons: StandardButton.Save | StandardButton.Cancel
    /*
    contentItem: Rectangle {
        width: 640
        height: 420
        color: "#0000ff"
    }*/
    Calendar {
              id: calendar
              onDoubleClicked: dateDialog.click(StandardButton.Save)
          }

}


