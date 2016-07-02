import QtQuick 2.0
import QtQuick.Controls 1.3
import "js/Utils.js" as Utils

MenuBar {
    id: menubar
    signal sig_toggle_sidebar()
    Menu {
        title: qsTr("File")
        MenuItem {
            text: qsTr("&Open")
            shortcut: "Ctrl+O"
            onTriggered: console.log("Open action triggered");
        }
        MenuItem {
            text: qsTr("Exit")
            shortcut: "Ctrl+Q"
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
        MenuItem {
            text: qsTr("&Hide Menu")
            shortcut: "Ctrl+M"
            onTriggered: {}
        }

    }
}
