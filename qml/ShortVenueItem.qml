import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property variant venueIcon
    property variant venueInfo

    width: parent.width
    height: Math.max(venue_icon.height, venue_name_label.height + venue_address_label.height)

    Image {
        id: venue_icon
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: Theme.paddingMedium
        anchors.leftMargin: Theme.paddingMedium;
        width: 64;
        height: 64;
        source: (venueIcon !== "") ? (venueIcon.prefix + width + venueIcon.suffix) : ""
    }

    Label {
        id: venue_name_label
        anchors.left: venue_icon.right
        anchors.right: parent.right
        anchors.top: parent.top;
        anchors.rightMargin: Theme.paddingMedium;
        anchors.leftMargin: Theme.paddingMedium;

        wrapMode: Text.Wrap
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeLarge

        text: venueInfo.name
    }

    Label {
        id: venue_address_label
        anchors.left: venue_icon.right
        anchors.right: parent.right
        anchors.top: venue_name_label.bottom;
        anchors.rightMargin: Theme.paddingMedium;
        anchors.leftMargin: Theme.paddingMedium;

        wrapMode: Text.Wrap
        color: Theme.secondaryColor
        font.pixelSize: Theme.fontSizeSmall

        text: (venueInfo.location.address !== undefined) ? venueInfo.location.address : ""
    }
}
