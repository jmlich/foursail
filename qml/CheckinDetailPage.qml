import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: page
    property string venue_id
    property alias venue_name: venue_name_label.text
    property alias venue_address: venue_address_label.text
    property alias icon: venue_category_icon.source
    property string event;

    property double lat;
    property double lon;
    property double deviceLat;
    property double deviceLon;


    property bool venue_liked: false

    property alias comment: comment_textarea.text
    property alias image: checkinImage.source
    property alias twitter: twitter_switch.checked
    property alias facebook: facebook_switch.checked

    signal switchToPhotos();
    signal switchToTips();
    signal switchToListed();
    signal venueLike();

    MapPage {
        id: mapPage;
        lat: page.lat
        lon: page.lon
        deviceLat: page.deviceLat
        deviceLon: page.deviceLon
    }

    ImagesPage {
        id: imagesPage

        onImageSelected: {
            checkinImage.source = url
            pageStack.navigateBack (PageStackAction.Animated)
        }
    }


    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: column.height


        PullDownMenu {
            MenuItem {
                //% "Photos"
                text: qsTrId("checkin-photos-menu")
                onClicked: switchToPhotos();
            }
            MenuItem {
                //% "Tips"
                text: qsTrId("checkin-tips-menu")
                onClicked: switchToTips();
            }
            MenuItem {
                //% "Listed"
                text: qsTrId("checkin-listed-menu")
                onClicked: switchToListed();
            }

            MenuItem {
                //% "Specials"
                text: qsTrId("checkin-specials")
//                onClicked: switchToSpecials()
                visible: false;
            }

            MenuItem {
                visible: false; // FIXME venue_liked must be filled first
                text: venue_liked
                //% "Dislike"
                      ? qsTrId("checkin-dislike-venue-menu")
                        //% "Like"
                      : qsTrId("checkin-like-venue-menu")
                onClicked: {
                    venue_liked = !venue_liked;
                }
            }
        }


        Column {
            id: column
            width: parent.width

            DialogHeader {
                id: dialogHeader;
                //% "Checkin"
                acceptText: qsTrId("venue-checkin-accept")
            }

            Item {
                width: parent.width
                height: Math.max(venue_category_icon.height, venue_name_label.height + venue_address_label.height)

                Image {
                    id: venue_category_icon
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: Theme.paddingMedium;
                    anchors.leftMargin: Theme.paddingMedium;
                    width: 64;
                    height: 64;

                }

                Label {
                    id: venue_name_label
                    anchors.left: venue_category_icon.right
                    anchors.right: parent.right
                    anchors.top: parent.top;
                    anchors.rightMargin: Theme.paddingMedium;
                    anchors.leftMargin: Theme.paddingMedium;

                    wrapMode: Text.Wrap
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                }
                Label {
                    id: venue_address_label
                    anchors.left: venue_category_icon.right
                    anchors.right: parent.right
                    anchors.top: venue_name_label.bottom;
                    anchors.rightMargin: Theme.paddingMedium;
                    anchors.leftMargin: Theme.paddingMedium;

                    wrapMode: Text.Wrap
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
            TextArea {
                id: comment_textarea
                width: parent.width
                height: 350
                //% "Write your comment here."
                placeholderText: qsTrId("venue-checkin-comment")
            }

            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Image {
                    id: checkinImage
                    height: 80
                    width: 80

                    visible: source != ""
                }

                IconButton {
                    icon.source: "image://Theme/icon-m-clear"
                    visible: checkinImage.source != ""
                    onClicked: checkinImage.source = ""
                }
            }

            Button {
                //% "Add image"
                text: qsTrId("venue-checkin-add-image")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    pageStack.push(imagesPage)
                }
            }

            TextSwitch {
                id: facebook_switch
                //% "Share to Facebook"
                text: qsTrId("venue-checkin-share-to-facebook-button")
            }

            TextSwitch {
                id: twitter_switch
                //% "Share to Twitter"
                text: qsTrId("venue-checkin-share-to-twitter-button")
            }

            Button {
                //% "Show on Map"
                text: qsTrId("venue-checkin-show-on-map-button")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    pageStack.push(mapPage)
                }
            }
        }
    }
}
