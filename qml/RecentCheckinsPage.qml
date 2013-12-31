import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: model
    property bool loading;

    signal refresh();
    signal switchToNearbyVenues();

    ListModel {
        id: model;
    }

    SilicaListView {
        id: listView
        model: model
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Recent Checkins")
        }
        spacing: 10;

        PullDownMenu {
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
                text: firstName + " " + lastName + " @ " + venueName
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap
            }

            Label {
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

            onClicked: console.log("Clicked " + index)
        }
        VerticalScrollDecorator {}
    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (model.count === 0)
        running: visible;
    }

    Label {
        anchors.centerIn: parent;
        visible: !loading && (model.count === 0)
        text: qsTr("Offline")
    }

}





