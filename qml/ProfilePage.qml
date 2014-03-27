import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property string uid: "self"

    property alias profile_photo_url: userPhoto.source
    property alias user_name: user_name_field.title
    property alias user_home_city: userHomeCity.text

    property alias badges_count: badges_count_label.text
    property alias tips_count: tips_count_label.text
    property alias friends_count: friends_count_label.text
    property alias mayorships_count: mayorships_count_label.text
    property alias checkins_count: checkins_count_label.text
    property alias lists_count: lists_count_label.text
    property alias photos_count: photos_count_label.text;
    property alias notifications_count: notifications_count_label.text
    property int scores_recent
    property int scores_max


    signal switchToHistory();
    signal switchToRecentCheckins();
    signal switchToNearbyVenues();
    signal switchToBadges();
    signal switchToNotifications();
    signal switchToTips();
    signal switchToFriends();
    signal switchToLeaderboard();
    signal switchToLists();
    signal switchToPhotos();
    signal switchToMayorships();
    signal switchToMyProfile();

    onUidChanged: { // details should be empty while loading
        userPhoto.source = "";
        user_name_field.title = "";
        userHomeCity.text = "";

        badges_count_label.text = "";
        tips_count_label.text = "";
        friends_count_label.text = "";
        mayorships_count_label.text = "";
        checkins_count_label.text = "";
        lists_count_label.text = "";
        photos_count_label.text = "";
        notifications_count_label.text = "";
        scores_recent = 0;
        scores_max = 1;
    }


    SilicaFlickable {

        anchors.fill: parent;

        Column {
            width: parent.width

            PullDownMenu {

                MenuItem {
                    //% "My Profile"
                    text: qsTrId("profile-my-profile-menu")
                    onClicked: switchToMyProfile();
                    visible: (uid !== "self")
                }

                MenuItem {
                    //% "Recent Checkins"
                    text: qsTrId("profile-recent-checkins-menu")
                    onClicked: switchToRecentCheckins()
                }

                MenuItem {
                    //% "Nearby Venues"
                    text: qsTrId("profile-nearby-venues-menu")
                    onClicked: switchToNearbyVenues();
                }

            }


            PageHeader {
                id: user_name_field

            }


            Item {
                height: 158
                width: parent.width

                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.margins: Theme.paddingMedium;


                Label {
                    id: userHomeCity

                    anchors.left: userPhoto.right
                    anchors.right: parent.right
                    anchors.bottom: userPhoto.verticalCenter
                    anchors.margins: Theme.paddingMedium

                    font.bold: false
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor;
                }

                Rectangle {
                    // score
                    anchors.left: userPhoto.right;
                    anchors.right: parent.right;
                    anchors.top: userHomeCity.bottom
                    anchors.margins: Theme.paddingMedium
                    height: scores_label.height;

                    border.width:  1
                    border.color: Theme.rgba(Theme.highlightBackgroundColor, 0.5)
                    color: "transparent"
                    visible: (scores_label !== "")

                    Rectangle {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom;
                        anchors.left: parent.left;
                        color: Theme.rgba(Theme.highlightBackgroundColor, 0.3)

                        width: (scores_recent*parent.width/scores_max)

                        Label {

                            color: Theme.primaryColor
                            id: scores_label
                            anchors.leftMargin:Theme.paddingMedium
                            anchors.left: parent.left;
                            text: scores_recent + " / " + scores_max
                        }
                    }


                    MouseArea {
                        anchors.fill: parent;
                        onClicked: switchToLeaderboard()
                    }
                }

                Image {
                    anchors.fill: userPhoto
                    source: "./images/blank_boy.png"
                    visible: (userPhoto.status !== Image.Ready)
                }

                Image {
                    id: userPhoto
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    width: 128;
                    height: 128;

                }
            }

            BackgroundItem {
                visible: (uid == "self")
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    //% "Checkins"
                    text: qsTrId("profile-checkins")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }


                Label {
                    id: checkins_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;

                }

                onClicked: switchToHistory();
            }

            BackgroundItem {
                visible: (uid == "self")
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    //% "Notifications"
                    text: qsTrId("profile-notifications")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: notifications_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;

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
                    //% "Badges"
                    text: qsTrId("profile-badges")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: badges_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;

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
                    //% "Mayorships"
                    text: qsTrId("profile-mayorships")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: mayorships_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;

                }
                onClicked: switchToMayorships();
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    //% "Tips"
                    text: qsTrId("profile-tips")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: tips_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;

                }
                onClicked: switchToTips()
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    //% "Friends"
                    text: qsTrId("profile-friends")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id:friends_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;
                }
                onClicked: switchToFriends()
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    //% "Lists"
                    text: qsTrId("profile-lists")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: lists_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;

                }
                onClicked: switchToLists()
            }

            BackgroundItem {
                width: parent.width
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    //% "Photos"
                    text: qsTrId("profile-photos")
                    color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: photos_count_label
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: Theme.fontSizeMedium
                    color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.margins: Theme.paddingMedium;

                }
                onClicked: switchToPhotos()
            }

        }
    }
}
