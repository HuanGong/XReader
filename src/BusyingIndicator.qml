import QtQuick 2.0
import QtQuick 2.2

Image {
    id: container

    source: "images/busy.png";

    NumberAnimation on rotation {
        running: container.visible
        from: 0; to: 360;
        loops: Animation.Infinite;
        duration: 1200
    }
}
