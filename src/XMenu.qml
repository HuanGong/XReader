import QtQuick 2.0
import QtQuick.Controls 1.3

MenuBar {
    signal sig_toggle_sidebar()
    Menu {
        title: qsTr("File")
        MenuItem {
            text: qsTr("&Open")
            onTriggered: console.log("Open action triggered");
        }
        MenuItem {
            text: qsTr("Exit")
            onTriggered: Qt.quit();
        }
    }

    Menu {
        title: qsTr("View")

        MenuItem {
            text: qsTr("&Toggle Sidebar")
            shortcut: "Ctrl+B"
            onTriggered: {sig_toggle_sidebar(); console.log("View action triggered");}
        }
    }
}
