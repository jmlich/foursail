import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property int friends_count: 0;
    property int checkins_count: 0;
    property int tips_count: 0;
    property string profile_photo_url;
    property string user_name;
    property string user_home_city;

    signal switchToHistory();
    signal switchToRecentCheckins();
    signal switchToNearbyVenues();
    signal switchToBadges();
    signal switchToNotifications();
    signal switchToTips();


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
                id: parentRect
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
                    id: userHomeCity

                    anchors.leftMargin: Theme.paddingMedium;
                    anchors.top: userName.bottom
                    anchors.topMargin: Theme.paddingSmall;
                    anchors.left: parent.left
                    anchors.right: userPhoto.left

                    font.bold: false
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                    text: user_home_city
                }

                Row
                {
                    anchors.right: userPhoto.left
                    anchors.left: parent.left
                    anchors.margins: Theme.paddingMedium;
                    anchors.bottom: parent.bottom
                    spacing: 10

                    BackgroundItem {
                        width: (parentRect.width - userPhoto.width - 3 * Theme.paddingMedium - parent.spacing) / 2
                        height: checkinsLabel.height
                        Label {
                            id: checkinsLabel

                            anchors.verticalCenter: parent.verticalCenter;
                            anchors.left: parent.left;
                            anchors.right: parent.right;
                            anchors.margins: Theme.paddingSmall;

                            horizontalAlignment: Text.AlignHCenter

                            color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor;
                            text: qsTr ("Checkins: ") + checkins_count;
                        }
                        onClicked: switchToHistory();
                    }

                    BackgroundItem {
                        width: (parentRect.width - userPhoto.width - 3 * Theme.paddingMedium - parent.spacing) / 2
                        height: tipsLabel.height
                        Label {
                            id: tipsLabel

                            anchors.verticalCenter: parent.verticalCenter;
                            anchors.left: parent.left;
                            anchors.right: parent.right;
                            anchors.margins: Theme.paddingSmall;

                            horizontalAlignment: Text.AlignHCenter

                            color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor;
                            text: qsTr ("Tips: ") + tips_count;
                        }
                        onClicked: switchToTips();
                    }
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
