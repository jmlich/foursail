import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0

ApplicationWindow {

    initialPage: nearbyVeneuesPage
    cover: coverPage


    RecentCheckinsPage {
        id: recentCheckinsPage;
        loading: (data.countLoading > 0)

        onSwitchToNearbyVenues: {
            pageStack.replace(nearbyVeneuesPage)

        }
        onRefresh: {
            data.posReady = false;
            positionSource.active = true
            data.refresh();
        }
    }

    NearbyVenuesPage {
        id: nearbyVeneuesPage;
        loading: ( (data.countLoading > 0) || positionSource.active)

        onSwitchToRecentCheckins: {
            pageStack.replace(recentCheckinsPage)
        }
        onSwitchToSearchVenue: {
            pageStack.push(searchVenuePage)
        }

        onSwitchToAddVenue: {
            pageStack.push(addVenuePage)
        }

        onRefresh: {
            data.posReady = false;
            positionSource.active = true
            m.clear()
            outputType = "nearby"
            data.refresh();
        }

        onCheckin: {
            data.checkin(venue_id)
            pageStack.push(checkinResultPage)
        }

        onCheckinDetail: {
            checkinDetailPage.venue_id = venue_id;
            checkinDetailPage.venue_name = name;
            checkinDetailPage.venue_address = address;
            checkinDetailPage.icon = icon;
            checkinDetailPage.comment = "";
            checkinDetailPage.lat = lat;
            checkinDetailPage.lon = lon;
            pageStack.push(checkinDetailPage)
        }
    }

    AddVenuePage {
        id: addVenuePage;
    }

    SearchVenuePage {
        id: searchVenuePage;
        onAccepted: {
            nearbyVeneuesPage.m.clear()
            nearbyVeneuesPage.outputType = "search"
            data.search(searchString)
            console.log("search: " + searchString)
        }
    }

    CheckinResultPage {
        id: checkinResultPage;
    }

    CheckinDetailPage {
        id: checkinDetailPage;
        onAccepted: {
            data.checkin(venue_id, comment, twitter, facebook)
            //            pageStack.push(checkinResultPage)
        }
        acceptDestination: checkinResultPage
        acceptDestinationAction: PageStackAction.Replace
    }



    CoverPage {
        id: coverPage
        onRefresh: {
            data.posReady = false;
            data.refresh()
            //            data.recentCheckins();
            positionSource.active = true; // novou polohu
        }
        labelText: data.lastCheckin
        updateDate: data.lastCheckinDate
        checkinPhotoSource: data.lastCheckinPhoto
        loading: (data.countLoading > 0)
    }


    Data {
        id: data;
        anchors.fill: parent;
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
        onPositionChanged: {
            if (position.latitudeValid) {
                var coord = position.coordinate;
                //            console.log("Coordinate:", coord.longitude, coord.latitude);
                data.lat = coord.latitude;
                data.lon = coord.longitude;

                data.posReady = true;
                //            data.nearbyVenues();
                active = false;
            }
        }
    }



}


