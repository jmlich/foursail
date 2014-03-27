import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: listmodel
    property bool loading;
    property string last_error;

    //    signal refresh();
    //    signal switchToNearbyVenues();
    //    signal switchToMyProfile();
    //    signal checkinDetail(string venue_id, string name, string address, url icon, double lat, double lon)
    //    signal friendDetail(variant model);

    ListModel {
        id: listmodel;

    }


    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        header: PageHeader {
            //% "Notifications"
            title: qsTrId("notifications-title")
        }
        spacing: Theme.paddingMedium;

        ViewPlaceholder {
            enabled: !loading && (listmodel.count === 0)
            //% "You have no notifications"
            text: (last_error !== "") ? last_error : qsTrId("notifications-empty")
        }

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            Image {
                id: notificationImage;
                width: 88
                height: 88

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Theme.paddingMedium

                source:  ((model.image.fullPath !== undefined) ? model.image.fullPath : ((model.image.prefix !== undefined) ? (model.image.prefix + model.image.sizes[1] + model.image.name) : ""))
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


}





