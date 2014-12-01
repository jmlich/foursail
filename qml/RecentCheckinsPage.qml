import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: listmodel
    property bool loading;
    property string last_error;

    signal refresh();
    signal switchToNearbyVenues();
    signal switchToMyProfile();
    signal checkinDetail(string venue_id, string name, string address, url icon, double lat, double lon)
    signal friendDetail(variant model);
    signal likeCheckin(string checkinId, bool value)

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        spacing: Theme.paddingMedium;
        header: PageHeader {
            //% "Recent Checkins"
            title: qsTrId("recent-checkins-title")
        }

        ViewPlaceholder {
            enabled: !loading && (listmodel.count === 0)
            //% "None of your friends checked in yet"
            text: (last_error !== "") ? last_error : qsTrId("recent-checkins-empty")
        }

        PullDownMenu {
            MenuItem {
                //% "My Profile"
                text: qsTrId("recent-checkins-my-profile-menu")
                onClicked: switchToMyProfile();
            }
            MenuItem {
                //% "Nearby Venues"
                text: qsTrId("recent-checkins-nearby-venues-menu")
                onClicked: switchToNearbyVenues();
            }
            MenuItem {
                //% "Refresh"
                text: qsTrId("recent-checkins-refresh-menu")
                onClicked: refresh();
            }
        }

        property Item contextMenu

        delegate: Item  {
            id: myListItem
            height: (menuOpen ? listView.contextMenu.height : 0) +  delegate.height;

            width: parent.width

            property bool menuOpen: ((listView.contextMenu  !== null) && (listView.contextMenu.parent === myListItem))
            BackgroundItem {
                id: delegate

                width: parent.width
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
                    anchors.leftMargin: Theme.paddingMedium;
                    anchors.rightMargin: Theme.paddingMedium;
                    textFormat: Text.RichText
                    text: firstName +" " + lastName + " @ " + venueName
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    wrapMode: Text.Wrap
                }

                Label {
                    id: addressLabel
                    anchors.top: personNameLabel.bottom;
                    anchors.left: personPhoto.right
                    anchors.right: parent.right
                    anchors.leftMargin: Theme.paddingMedium;
                    anchors.rightMargin: Theme.paddingMedium;
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: address + ((address.length > 0) ? "\n" : "") +
                          Format.formatDate(createdDate, Formatter.DurationElapsed)
                    wrapMode: Text.Wrap

                }

                Label {
                    id: shoutLabel;
                    anchors.top: addressLabel.bottom;
                    anchors.left: personPhoto.right
                    anchors.right: parent.right
                    anchors.leftMargin: Theme.paddingMedium;
                    anchors.rightMargin: Theme.paddingMedium
                    wrapMode: Text.Wrap
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: shout
                    visible: (shout !== "")
                    height: visible ? paintedHeight : 0

                }

                Image {
                    id: shoutPhotoImage
                    anchors.top: shoutLabel.bottom
                    anchors.left: personPhoto.right
                    anchors.right: parent.right
                    anchors.leftMargin: Theme.paddingMedium;
                    anchors.rightMargin: Theme.paddingMedium
                    fillMode: Image.PreserveAspectFit
                    source: shoutPhoto
                    visible: (shoutPhoto !== "")
                }


//                onClicked: console.log("Clicked " + index)
                onClicked: {
                    if (listView.contextMenu === null) {
                        listView.contextMenu = contextMenuComponent.createObject(listView)
                    }
                    listView.contextMenu.checkinId = checkinId;
                    listView.contextMenu.liked = liked;
                    listView.contextMenu.vid = vid;
                    listView.contextMenu.venueName = venueName;
                    listView.contextMenu.address = address;
                    listView.contextMenu.venuePhoto = venuePhoto;
                    listView.contextMenu.lat = lat;
                    listView.contextMenu.lon = lon;
                    listView.contextMenu.index = index;
                    listView.contextMenu.firstName = firstName;
                    listView.contextMenu.lastName = lastName;

                    listView.contextMenu.show(myListItem)
                }
            }
        }

        Component {
            id: contextMenuComponent
            ContextMenu {
                property string checkinId;
                property bool liked;
                property string vid
                property string venueName;
                property string address;
                property string venuePhoto
                property real lat
                property real lon
                property int index;
                property string firstName
                property string lastName

                MenuItem {
                    text: liked ?
                              //% "Dislike checkin"
                              qsTrId("recent-checkins-dislike") :
                              //% "Like checkin"
                              qsTrId("recent-checkins-like")
                    onClicked: {
                        liked = !liked;
                        likeCheckin(checkinId, liked);

                        // projection of like to current listmodel
                        for (var i = 0; i < listmodel.count; i++) {
                            var item = listmodel.get(i);
                            if (item.checkinId === checkinId) {
                                listmodel.setProperty(i, "liked", liked)
                            }
                        }
                    }
                }
                MenuItem {
                    //% "Profile"
                    text: qsTrId("recent-checkins-friend-profile");
                    onClicked: {
                        friendDetail(listmodel.get(index))
                    }

                }

                MenuItem {
                    //% "Venue"
                    text: qsTrId("recent-checkins-venue-detail")
                    onClicked: {
                        checkinDetail(vid, venueName, address, venuePhoto, lat, lon)
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }

}





