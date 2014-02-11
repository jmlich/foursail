import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property int friends_count: 0;
    property string profile_photo_url;
    property string user_name;
    property string user_home_city;

    signal switchToHistory();
    signal switchToRecentCheckins();
    signal switchToNearbyVenues();
    signal switchToBadges();
    signal switchToNotifications();


    SilicaFlickable {

        anchors.fill: parent;

        Column {
            width: parent.width

            PullDownMenu {

                MenuItem {
                    text: qsTr("Recent Checkins")
                    onClicked: switchToRecentCheckins()
                }
                MenuItem {
                    text: qsTr("Nearby Venues")
                    onClicked: switchToNearbyVenues();
                }
            }


            PageHeader {
                title: qsTr("My Profile")
            }


            Rectangle {
                height: 158
                width: parent.width

                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.margins: Theme.paddingMedium;

                radius: 5
                color: "transparent"
                border.color: Theme.highlightColor

                Label {
                    id: userName
                    anchors.margins: Theme.paddingMedium;
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: userPhoto.left

                    font.bold: true
                    color: Theme.primaryColor
                    text: user_name
                }

                Label {
                    anchors.top: userName.bottom
                    anchors.topMargin: Theme.paddingSmall;
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingMedium;
                    anchors.right: userPhoto.left
                    anchors.rightMargin: Theme.paddingMedium;

                    color: Theme.primaryColor
                    text: user_home_city
                }

                Image {
                    id: userPhoto
                    anchors.margins: Theme.paddingMedium;
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    source: profile_photo_url
                }
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    text: qsTr("History")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: switchToHistory();
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    text: qsTr("Badges")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                onClicked: switchToBadges();
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    text: qsTr("Notifications")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: switchToNotifications();
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    text: qsTr("Mayorships")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;
                    text: "N/A"
                }
                onClicked: console.log("Mayorships")
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    text: qsTr("Friends")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;
                    text: friends_count
                }
                onClicked: console.log("Friends")
            }
        }
    }
}
