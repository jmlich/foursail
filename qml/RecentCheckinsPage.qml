import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: listmodel
    property bool loading;

    signal refresh();
    signal switchToNearbyVenues();
    signal switchToMyProfile();
    signal checkinDetail(string venue_id, string name, string address, url icon, double lat, double lon)
    signal friendDetail(variant model);

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Recent Checkins")
        }
        spacing: 10;

        PullDownMenu {
            MenuItem {
                text: qsTr("My Profile")
                onClicked: switchToMyProfile();
            }
            MenuItem {
                text: qsTr("Nearby Venues")
                onClicked: switchToNearbyVenues();
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh();
            }
        }

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            Image {
                id: personPhoto
                source: photo
                anchors.left: parent.left;
                anchors.top: parent.top;
                width: 86;
                height: 86;

            }

            Label {
                id: personNameLabel
                anchors.top: parent.top;
                anchors.left: personPhoto.right
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                textFormat: Text.RichText
                text: "<style type='text/css'>a:link{color:"+Theme.primaryColor+"; text-decoration: none;} a:visited{color:"+Theme.primaryColor+"}</style> <a href=\"name\">" + firstName +" " + lastName + "</a> @ <a href=\"venue\">" + venueName + "</a>"
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap
                onLinkActivated: {
                    if (link == "venue") {
                        checkinDetail(vid, venueName, address, venuePhoto, lat, lon)
                    }
                    if (link == "name") {
                        friendDetail(listmodel.get(index))
                    }
                }
            }

            Label {
                id: addressLabel
                anchors.top: personNameLabel.bottom;
                anchors.left: personPhoto.right
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: address + ((address.length > 0) ? "\n" : "") + F.formatDate(createdDate)
                wrapMode: Text.Wrap

            }

            Label {
                id: shoutLabel;
                anchors.top: addressLabel.bottom;
                anchors.left: personPhoto.right
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                wrapMode: Text.Wrap
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
                text: shout
                visible: (shout !== "")
                height: visible ? paintedHeight : 0

            }


            onClicked: console.log("Clicked " + index)
        }
        VerticalScrollDecorator {}
    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }

    Label {
        anchors.centerIn: parent;
        visible: !loading && (listmodel.count === 0)
        text: qsTr("Offline")
    }

}





