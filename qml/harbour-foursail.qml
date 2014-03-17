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
        onSearch: {
            nearbyVeneuesPage.m.clear()
            nearbyVeneuesPage.outputType = "search"
            data.search(searchString)
        }
        onSaveHistory: {
            data.saveSearchHistory(str)

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

    LeaderboardPage {
        id: leaderboardPage
        loading: (data.countLoading > 0)
    }


    MyProfilePage {
        id: myProfilePage

        onSwitchToHistory: {
            data.checkinHistory("self")
            pageStack.push(selfCheckinsPage)
        }

        onSwitchToLists: {
            data.lists("self")
            pageStack.push(listsPage);
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

        onSwitchToFriends: {
            data.friends("self")
            pageStack.push(friendPage)
        }

        onSwitchToTips: {
            data.tips("self");
            tipsPage.uid = "self"
            pageStack.push(tipsPage)
        }

        onStatusChanged: {
            if (status === PageStatus.Activating) {
                data.profile ("self")
            }
        }

        //        onStatusChanged: {
        //            if ((status === PageStatus.Activating) && (selfCheckinsPage.m.count === 0)) {
        //            }
        //        }

    onSwitchToLeaderboard:  {
        data.leaderboard()
        pageStack.push(leaderboardPage)
    }

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

    ListsPage {
        id: listsPage;
        loading: (data.countLoading > 0)
        onSwitchToListDetailPage: {
            data.listDetails(lid)
            pageStack.push(listDetailPage)
        }
        onSwitchToAddAndEditList: {
            addAndEditListPage.dialogHeaderText = (lid !== "") ? qsTr("Edit List") : qsTr("Create List")
            addAndEditListPage.listId = lid;
            addAndEditListPage.listName = name;
            addAndEditListPage.listDescription = description;
            pageStack.push(addAndEditListPage)
        }
    }

    ListDetailPage {
        id: listDetailPage;
        loading: (data.countLoading > 0)
    }

    AddAndEditListPage {
        id: addAndEditListPage

    }

    FriendsPage {
        id: friendPage
        loading: (data.countLoading > 0)

        onRefresh: {
            data.friends("self");
        }
        onRemoveFriend: {
            data.removeFriend(uid);
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

        // TBD
//        onStatusChanged: {
//            if (status === PageStatus.Activating) {
//                data.profile (uid)
//            }
//        }
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

    TipsPage {
        id: tipsPage
        loading: (data.countLoading > 0)

//        onRefresh: {
//            data.tips(uid)
//        }
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


