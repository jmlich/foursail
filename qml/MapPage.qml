import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page;

    property alias lat: map.targetLat
    property alias lon: map.targetLon


    PageHeader {
        title: qsTr("Map")
    }



    PinchMap {
        clip: true;
        pageActive: (page.status === PageStatus.Active)
        id: map
        anchors.fill: parent;

    }
}
