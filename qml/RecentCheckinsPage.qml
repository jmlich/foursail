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
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
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


                onClicked: console.log("Clicked " + index)
                onPressAndHold: {
                    console.log("press and hold")
                    if (listView.contextMenu === null) {
                        listView.contextMenu = contextMenuComponent.createObject(listView)
                    }
                    listView.contextMenu.checkinId = checkinId
                    listView.contextMenu.liked = liked
                    listView.contextMenu.show(myListItem)
                }
            }
        }

        Component {
            id: contextMenuComponent
            ContextMenu {
                property string checkinId;
                property bool liked;
                MenuItem {
                    text: liked ?
                              //% "Dislike"
                              qsTrId("recent-checkins-dislike") :
                              //% "Like"
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





