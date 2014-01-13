import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: listmodel
    property bool loading;

    //    signal refresh();
    //    signal switchToNearbyVenues();
    //    signal switchToMyProfile();
    //    signal checkinDetail(string venue_id, string name, string address, url icon, double lat, double lon)
    //    signal friendDetail(variant model);

    ListModel {
        id: listmodel;

    }

    function getMaxValue() {
        var maxVal = 0;
        for (var i = 0; i < listmodel.count; i++) {
            var item = listmodel.get(i);
            maxVal = Math.max(maxVal, item.createdAt);
        }
        return maxVal;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Notifications")
        }
        spacing: 10;

        /*
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

        */

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            Image {
                id: notificationImage;
                width: 44
                height: 44

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Theme.paddingMedium

                source:  ((model.image.fullPath !== undefined) ? model.image.fullPath : ((model.image.prefix !== undefined) ? (model.image.prefix + model.image.sizes[0] + model.image.name) : ""))
            }



            Label {
                id: notifiLabel
                anchors.left: notificationImage.right
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium
                textFormat: Text.RichText
                text: model.text
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap
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





