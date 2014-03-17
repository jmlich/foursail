import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property alias m: listmodel
    property bool loading;
    property string listName

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

        delegate: BackgroundItem {
            id: delegate

            width: parent.width

            height: contentItem.childrenRect.height

            ShortVenueItem {
                venueIcon: (venue.categories[0] !== undefined) ? venue.categories[0].icon : ""
                venueInfo: venue
            }
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





