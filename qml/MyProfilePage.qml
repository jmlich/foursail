import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    signal switchToHistory();
    signal switchToRecentCheckins();
    signal switchToNearbyVenues();
    signal switchToBadges();

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
                    text: "N/A"
                }
                onClicked: console.log("Friends")
            }
        }
    }
}
