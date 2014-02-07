import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0

ApplicationWindow {

    initialPage: nearbyVeneuesPage
    cover: coverPage

    NotificationPopup {
        id: notificationPopup;

        secondaryText: qsTr("Tap to show")

        enabled: (notificationsPage.status === PageStatus.Inactive)

        onCanceled: {
            pageStack.push(notificationsPage)
        }
    }

    NotificationsPage {
        id: notificationsPage
        loading: (data.countLoading > 0)
        onStatusChanged: {
            if (notificationsPage.status === PageStatus.Activating) {
                data.notifications()
            }
            if (notificationsPage.status === PageStatus.Deactivating) {

                var mark = false;
                for (var i = 0; i < m.count; i++) {
                    var item = m.get(i);
                    if (item.unread) {
                        mark = true;
                    }
                }

                if (mark) {
                    data.notificationsMarkAsRead(Math.ceil(new Date().getTime()/1000))
                }

            }

        }
    }

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
        onFriendDetail: {
            friendDetailPage.name = model.firstName +" " + model.lastName
            friendDetailPage.icon = model.photo
            friendDetailPage.uid = model.uid
            pageStack.push(friendDetailPage)
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
//            if ((status === PageStatus.Activating) && (m.count === 0) && (outputType !== "nearby")) {
//                data.nearbyVenues();
//            }
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
            checkinDetailPage.lat = lat;
            checkinDetailPage.lon = lon;
            pageStack.push(checkinDetailPage)
        }
    }

    AddVenuePage {
        id: addVenuePage;
        onSwitchToCategoriesPage: {
            data.venuesCategories()
            pageStack.push(categoriesPage)
        }
        onAccepted: {
            data.addVenue(venueName, cid, address,crossStreet, city, state, zip, phone, twitter, description, url);
            pageStack.replace(checkinDetailPage, PageStackAction.Immediate)
        }
    }

    SearchVenueDialog {
        id: searchVenuePage;
        onAccepted: {
            nearbyVeneuesPage.m.clear()
            nearbyVeneuesPage.outputType = "search"
            data.search(searchString)
        }
    }

    CheckinResultPage {
        id: checkinResultPage;
    }

    CheckinDetailPage {
        id: checkinDetailPage;

        onAccepted: {
            checkinResultPage.m.clear();
            data.checkin(venue_id, comment, twitter, facebook)
            //            pageStack.push(checkinResultPage)
        }

        acceptDestination: checkinResultPage
        acceptDestinationAction: PageStackAction.Replace
        deviceLat: positionSource.position.coordinate.latitude;
        deviceLon: positionSource.position.coordinate.longitude;

    }


    MyProfilePage {
        id: myProfilePage

        onSwitchToHistory: {
            data.checkinHistory("self")
            pageStack.push(selfCheckinsPage)
        }

        onSwitchToNearbyVenues: {
            pageStack.replace(nearbyVeneuesPage)
        }

        onSwitchToRecentCheckins: {
            pageStack.replace(recentCheckinsPage)
        }

        onSwitchToNotifications: {
            pageStack.push(notificationsPage)
        }

        onSwitchToBadges: {
            data.badges("self")
            pageStack.push(badgesPage)
        }

        //        onStatusChanged: {
        //            if ((status === PageStatus.Activating) && (selfCheckinsPage.m.count === 0)) {
        //            }
        //        }

        SelfCheckinsPage {
            id: selfCheckinsPage;
            loading: (data.countLoading > 0)

            onRefresh: {
                m.clear();
                data.selfCheckins();
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

    }

    FriendDetailPage {
        id: friendDetailPage
        onSwitchToBadges: {
            data.badges(uid)
            pageStack.push(badgesPage)
        }
        onSwitchToCheckinHistory: {
            data.checkinHistory(uid);
            pageStack.push(selfCheckinsPage)
        }
    }

    CategoriesPage {
        id: categoriesPage
        onSelected: {
            addVenuePage.cid = cid;
            addVenuePage.category_icon = icon;
            addVenuePage.category_name = name;
            pageStack.pop(addVenuePage);
        }
    }

    BadgesPage {
        id: badgesPage
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

            if (position.latitudeValid && ((new Date().getTime()-position.timestamp.getTime()) < 60000)) { // position could be valid but very old
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


