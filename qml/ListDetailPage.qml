import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property alias m: listmodel
    property bool loading;
    property string last_error;
    property string listName

    signal checkinDetail(string venue_id, string name, string address, url icon, double lat, double lon)


    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent

        header: PageHeader {
            title: listName
        }

        ViewPlaceholder {
            enabled: !loading && (listmodel.count === 0)
            text: (last_error !== "") ? last_error : qsTr("Add new item into the list")
        }

        delegate: BackgroundItem {
            id: delegate

            width: parent.width

            height: contentItem.childrenRect.height

            ShortVenueItem {
                id: shortVenueItem;
                venueIcon: (venue.categories[0] !== undefined) ? venue.categories[0].icon : ""
                venueInfo: venue
            }

            Image {
                anchors.rightMargin: Theme.paddingMedium
                anchors.top: shortVenueItem.top
                anchors.right: shortVenueItem.right
                source: (venue.beenHere !== undefined && venue.beenHere.marked) ? "./images/icon-m-framework-done.png" : ""
            }

            onClicked: {
                var street = (venue.location.address !== undefined) ? venue.location.address : "";
                var city   = (venue.location.city !== undefined) ? venue.location.city : "";
                var address = (street !== "") ? (street + ", " + city) : city;
                var icon = (venue.categories[0] !== undefined) ? venue.categories[0].icon : ""
                var lat = ((venue.location.lat !== undefined) ? venue.location.lat : 0);
                var lon = ((venue.location.lng !== undefined) ? venue.location.lng : 0);

                checkinDetail(venue.id, venue.name, address, icon.prefix+"64"+icon.suffix, lat, lon)

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





