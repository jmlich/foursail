import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0

ApplicationWindow {

    initialPage: nearbyVeneuesPage
    cover: coverPage

    NotificationPopup {
        id: notificationPopup;

        //% "Tap to show"
        secondaryText: qsTrId("tap-to-show")

        enabled: (notificationsPage.status === PageStatus.Inactive)

        onCanceled: {
            pageStack.push(notificationsPage)
        }
    }

    NotificationsPage {
        id: notificationsPage
        loading: (data.countLoading > 0)
        last_error: data.last_error
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
        last_error: data.last_error

        onSwitchToNearbyVenues: {
            pageStack.replace(nearbyVeneuesPage)

        }

        onSwitchToMyProfile: {
            profilePage.uid = "self"
            pageStack.replace(profilePage)
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

            var p = pageStack.find(function(page) { return page === checkinDetailPage; });
            if (p !== null) {
                pageStack.pop(checkinDetailPage)
            } else {
                pageStack.push(checkinDetailPage)
            }

        }
        onFriendDetail: {

            profilePage.uid = model.uid
            pageStack.push(profilePage)
        }

        onLikeCheckin: {
            data.likeCheckin(checkinId, value)
        }

    }

    NearbyVenuesPage {
        id: nearbyVeneuesPage;
        loading: ( (data.countLoading > 0) || positionSource.active)
        last_error: data.last_error

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
            profilePage.uid = "self"
            pageStack.replace(profilePage)
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

            var p = pageStack.find(function(page) { return page === checkinDetailPage; });
            if (p !== null) {
                pageStack.pop(checkinDetailPage)
            } else {
                pageStack.push(checkinDetailPage)
            }
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
            data.checkin(venue_id, event, comment, twitter, facebook)
            //            pageStack.push(checkinResultPage)
        }

        onSwitchToPhotos: {
            data.venuePhotos(venue_id)
            pageStack.push(photosPage)
        }

        onSwitchToTips: {
            data.venueTips(venue_id)
            pageStack.push(tipsPage)

        }

        onSwitchToListed: {
            data.venueListed(venue_id)

            var p = pageStack.find(function(page) { return page === listsPage; });
            if (p !== null) {
                pageStack.pop(listsPage)
            } else {
                pageStack.push(listsPage)
            }

        }

        onVenue_likedChanged: {
            data.likeVenue(venue_id, venue_liked)
        }


        acceptDestination: checkinResultPage
        acceptDestinationAction: PageStackAction.Replace
        deviceLat: positionSource.position.coordinate.latitude;
        deviceLon: positionSource.position.coordinate.longitude;

    }

    LeaderboardPage {
        id: leaderboardPage
        loading: (data.countLoading > 0)
        last_error: data.last_error
    }


    ProfilePage {
        id: profilePage

        loading: (data.countLoading > 0)

        onSwitchToMyProfile: {
            uid = "self";
            data.profile (uid)
        }

        onSwitchToHistory: {
            data.checkinHistory(uid)
            pageStack.push(selfCheckinsPage)
        }

        onSwitchToLists: {
            data.lists(uid)

            var p = pageStack.find(function(page) { return page === listsPage; });
            if (p !== null) {
                pageStack.pop(listsPage)
            } else {
                pageStack.push(listsPage)
            }

        }

        onSwitchToNearbyVenues: {
            pageStack.replace(nearbyVeneuesPage)
        }

        onSwitchToRecentCheckins: {
            var p = pageStack.find(function(page) { return page === recentCheckinsPage; });
            if (p !== null) {
                pageStack.pop(recentCheckinsPage)
            } else {
                pageStack.replace(recentCheckinsPage)
            }
        }

        onSwitchToNotifications: {
            pageStack.push(notificationsPage)
        }

        onSwitchToBadges: {
            data.badges(uid)
            pageStack.push(badgesPage)
        }

        onSwitchToFriends: {
            data.friends(uid)
            pageStack.push(friendPage)
        }

        onSwitchToTips: {
            data.tips(uid);
            tipsPage.uid = uid
            pageStack.push(tipsPage)
        }

        onSwitchToPhotos: {
            data.photos(uid);
            pageStack.push(photosPage)

        }

        onSwitchToLeaderboard:  {
            data.leaderboard()
            pageStack.push(leaderboardPage)
        }

        onSwitchToMayorships: {
            data.mayorships(uid)
            pageStack.push(mayorshipsPage)

        }

        onStatusChanged: {
            if (status === PageStatus.Activating) {
                data.profile (uid)
            }
        }

        //        onStatusChanged: {
        //            if ((status === PageStatus.Activating) && (selfCheckinsPage.m.count === 0)) {
        //            }
        //        }

        SelfCheckinsPage {
            id: selfCheckinsPage;
            loading: (data.countLoading > 0)
            last_error: data.last_error

            onCheckinDetail: {
                checkinDetailPage.venue_id = venue_id;
                checkinDetailPage.venue_name = name;
                checkinDetailPage.venue_address = address;
                checkinDetailPage.icon = icon;
                checkinDetailPage.comment = "";
                checkinDetailPage.lat = lat;
                checkinDetailPage.lon = lon;

                var p = pageStack.find(function(page) { return page === checkinDetailPage; });
                if (p !== null) {
                    pageStack.pop(checkinDetailPage)
                } else {
                    pageStack.push(checkinDetailPage)
                }
            }
        }

    }

    ListsPage {
        id: listsPage;
        loading: (data.countLoading > 0)
        last_error: data.last_error

        onSwitchToListDetailPage: {
            data.listDetails(lid)
            listDetailPage.m.clear();
            pageStack.push(listDetailPage)
        }
        onSwitchToAddAndEditList: {
            addAndEditListPage.listId = lid;
            addAndEditListPage.listName = name;
            addAndEditListPage.listDescription = description;
            pageStack.push(addAndEditListPage)
        }
    }

    ListDetailPage {
        id: listDetailPage;
        loading: (data.countLoading > 0)
        last_error: data.last_error

        onCheckinDetail: {
            checkinDetailPage.venue_id = venue_id;
            checkinDetailPage.venue_name = name;
            checkinDetailPage.venue_address = address;
            checkinDetailPage.icon = icon;
            checkinDetailPage.comment = "";
            checkinDetailPage.lat = lat;
            checkinDetailPage.lon = lon;

            var p = pageStack.find(function(page) { return page === checkinDetailPage; });
            if (p !== null) {
                pageStack.pop(checkinDetailPage)
            } else {
                pageStack.push(checkinDetailPage)
            }
        }
    }

    AddAndEditListPage {
        id: addAndEditListPage

    }

    FriendsPage {
        id: friendPage
        loading: (data.countLoading > 0)
        last_error: data.last_error

        onRefresh: {
            data.friends("self");
        }
        onRemoveFriend: {
            data.removeFriend(uid);
        }

        onFriendRequest:  {
            data.friendRequest(uid)
        }

        onShowFriend: {
            profilePage.uid = uid

            pageStack.pop(profilePage)
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
        loading: (data.countLoading > 0)
        last_error: data.last_error

    }

    PhotosPage {
        id: photosPage
        loading: (data.countLoading > 0)
        last_error: data.last_error

        onShowPhotoDetail: {
            photoDetailPage.addr = addr;
            pageStack.push(photoDetailPage);

        }
    }

    PhotoDetailPage {
        id: photoDetailPage
        onStatusChanged: {
            if (status === PageStatus.Inactive) {
                addr = "";
            }
        }
    }

    MayorshipsPage {
        id: mayorshipsPage;
        loading: (data.countLoading > 0)
        last_error: data.last_error

        onCheckinDetail: {
            checkinDetailPage.venue_id = venue_id;
            checkinDetailPage.venue_name = name;
            checkinDetailPage.venue_address = address;
            checkinDetailPage.icon = icon;
            checkinDetailPage.comment = "";
            checkinDetailPage.lat = lat;
            checkinDetailPage.lon = lon;

            var p = pageStack.find(function(page) { return page === checkinDetailPage; });
            if (p !== null) {
                pageStack.pop(checkinDetailPage)
            } else {
                pageStack.push(checkinDetailPage)
            }
        }

    }



    TipsPage {
        id: tipsPage
        loading: (data.countLoading > 0)
        last_error: data.last_error

        onLikeTip: {
            data.likeTip(tid, value);
        }

    }

    CoverPage {
        id: coverPage
        onRefresh: {
            data.nearbyVenues();
            data.recentCheckins();
        }
        onLike: {
            data.likeCheckin(checkin_id, true);
        }

        labelText: data.lastCheckin
        updateDate: data.lastCheckinDate
        checkinPhotoSource: data.lastCheckinPhoto
        checkin_id: data.lastCheckinId
        loading: (data.countLoading > 0)
        last_error: data.last_error


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


