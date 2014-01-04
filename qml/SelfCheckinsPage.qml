import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page

    property alias m: model
    property bool loading;

    signal refresh();
    signal switchToRecentCheckins();
    signal switchToNearbyVenues();
    signal checkinDetail(string venue_id, string name, string address, url icon, double lat, double lon)

    ListModel {
        id: model;
    }

    SilicaListView {
        id: listView
        model: model
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("History")
        }
        spacing: 10;

        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh()
            }
        }

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            Image {
                id: categoryPhoto
                source: photo_prefix + categoryPhoto.width + photo_suffix
                anchors.left: parent.left;
                anchors.top: parent.top;
                width: 64;
                height: categoryPhoto.width;

            }


            Label {
                id: venue_name_label
                anchors.top: parent.top;
                anchors.left: categoryPhoto.right
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                text: name
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap
            }


            Label {
                id: venue_address_label
                anchors.top: venue_name_label.bottom;
                anchors.left: categoryPhoto.right
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: address + ((address.length > 0) ? "\n" : "") + F.formatDate(createdDate)
                wrapMode: Text.Wrap

            }

            onClicked: {
                checkinDetail(vid, name, address, photo_prefix + "64" + photo_suffix, lat, lon)
            }

            onPressAndHold: checkin(vid)

        }
        VerticalScrollDecorator {}
    }

    BusyIndicator {
        visible: loading && (model.count === 0)
        running: visible;
        anchors.centerIn: parent;
    }

    Label {
        anchors.centerIn: parent;
        visible: !loading && (model.count === 0)
        text: qsTr("Offline")
    }

}




