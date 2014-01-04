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

        onSwitchToMyProfile: {
            pageStack.replace(myProfilePage)
        }

        onRefresh: {
            m.clear()
            data.recentCheckins()
        }

        onStatusChanged: {
            if ((status === PageStatus.Activating) && (m.count === 0)) {
                data.recentCheckins();
            }
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

        onSwitchToMyProfile: {
            pageStack.replace(myProfilePage)
        }

        onStatusChanged: {
            if ((status === PageStatus.Activating) && (m.count === 0)) {
                data.nearbyVenues();
            }
        }


        onRefresh: {
            m.clear()
            data.nearbyVenues();
            outputType = "nearby"

        }

        onCheckinDetail: {
            checkinDetailPage.venue_id = venue_id;
            checkinDetailPage.venue_name = name;
            checkinDetailPage.venue_address = address;
            checkinDetailPage.icon = icon;
            checkinDetailPage.comment = "";
            pageStack.push(checkinDetailPage)
        }
    }

    AddVenuePage {
        id: addVenuePage;
    }

    SearchVenueDialog {
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
        lat: positionSource.position.coordinate.latitude;
        lon: positionSource.position.coordinate.longitude;

        onAccepted: {
            data.checkin(venue_id, comment, twitter, facebook)
            //            pageStack.push(checkinResultPage)
        }
        acceptDestination: checkinResultPage
        acceptDestinationAction: PageStackAction.Replace
    }


    MyProfilePage {
        id: myProfilePage

        onSwitchToHistory: {
            pageStack.push(selfCheckinsPage)
        }

        onSwitchToNearbyVenues: {
            pageStack.replace(nearbyVeneuesPage)
        }

        onSwitchToRecentCheckins: {
            pageStack.replace(recentCheckinsPage)
        }

        onStatusChanged: {
            if ((status === PageStatus.Activating) && (selfCheckinsPage.m.count === 0)) {
                data.selfCheckins()
            }
        }

        SelfCheckinsPage {
            id: selfCheckinsPage;
            loading: (data.countLoading > 0)

            onRefresh: {
                m.clear();
                data.selfCheckins();
            }
        }

    }



    CoverPage {
        id: coverPage
        onRefresh: {
            data.nearbyVenues();
            data.recentCheckins();
        }
        onLike: {
            data.likeCheckin(checkin_id);
        }

        labelText: data.lastCheckin
        updateDate: data.lastCheckinDate
        checkinPhotoSource: data.lastCheckinPhoto
        checkin_id: data.lastCheckinId
        loading: (data.countLoading > 0)

        Component.onCompleted: {
            data.recentCheckins();
        }

    }


    Data {
        id: data;
        anchors.fill: parent;
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: !data.posReady
        onPositionChanged: {
            if (position.latitudeValid) {
                var coord = position.coordinate;
                //            console.log("Coordinate:", coord.longitude, coord.latitude);
                data.lat = coord.latitude;
                data.lon = coord.longitude;

                data.posReady = true;
            }
        }
        onActiveChanged: {
            console.log("gps status: "+ active)
        }
    }



}


