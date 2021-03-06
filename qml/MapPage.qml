import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page;

    property alias lat: map.targetLat
    property alias lon: map.targetLon

    property alias deviceLat: map.currentPositionLat
    property alias deviceLon: map.currentPositionLon

    property alias targetDragable: map.targetDragable



    PageHeader {
        id: pageHeader;
        //% "Map"
        title: qsTrId("map-title")
    }


    PinchMap {

        id: map
        anchors.top: pageHeader.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        clip: true;
        pageActive: (page.status === PageStatus.Active)

    }
}
