import QtQuick.LocalStorage 2.0 as Sql
import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0

Rectangle {

    id: data
    visible: false; // true when authentication

    property string dbName: "harbour-foursail"
    property string dbVersion: "1.0"
    property string dbDisplayName: "harbour-foursail"

    property string clientID: "ATG2VZ5I2E4IELFPC2U2HWU5WRFNRL2BAHXUEBZ5UHTM00D2"


    property int dbEstimatedSize: 100;

    property string accessToken
    property int lastUpdate: 0

    property int countLoading: 0;

    property string last_error: "";

    property real lat
    property real lon
    property bool posReady: false;
    property bool requestNearbyVenues: false;

    property string lastCheckin
    property date lastCheckinDate
    property url lastCheckinPhoto
    property string lastCheckinId


    property string foursquare_api_version: "20131016"
    //    property string locale: "en"

    function foo() {

    }

    ListModel {
        id: recentCheckinsModel
    }

    function saveSearchHistory(str) {
        console.log("config set searchHistory " + str)
        configSet("searchHistory", str)
    }

    function configSet(key, value) {
        //        console.log(key + " = " + value)

        var db = Sql.LocalStorage.openDatabaseSync(dbName, dbVersion, dbDisplayName, dbEstimatedSize);
        db.transaction(
                    function(tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Keys(key TEXT PRIMARY KEY, value TEXT)');
                        var rs = tx.executeSql('SELECT * FROM Keys WHERE key==?', [ key ]);

                        if (rs.rows.length === 0){
                            tx.executeSql('INSERT INTO Keys VALUES(?, ?)', [ key, value ]);
                        } else {
                            tx.executeSql('UPDATE Keys SET value=? WHERE key==?', [value, key]);
                        }
                    })
    }

    function configGet(key, default_value) {
        var db = Sql.LocalStorage.openDatabaseSync(dbName, dbVersion, dbDisplayName, dbEstimatedSize);
        var result = "";
        db.transaction(
                    function(tx) {

                        tx.executeSql('CREATE TABLE IF NOT EXISTS Keys(key TEXT PRIMARY KEY, value TEXT)');
                        var rs = tx.executeSql('SELECT * FROM Keys WHERE key=?', [ key ]);
                        if (rs.rows.length === 1 && rs.rows.item(0).value.length > 0){
                            result = rs.rows.item(0).value
                        }
                        else {
                            result = default_value;
                            console.log(key + " : " + result + " (default)")
                        }
                    }
                    )
        return result;
    }

    onPosReadyChanged: {
        if ( posReady && requestNearbyVenues && (accessToken !== "") ) {
            nearbyVenues();
        }

    }


    Component.onCompleted: {
        try {
            accessToken = configGet("accessToken", "");
            lastUpdate = parseInt(configGet("lastUpdate", 0));
            searchVenuePage.historyStr = configGet("searchHistory", "{}");


            lastCheckin = configGet("lastCheckin","")
            var d = configGet("lastCheckinDate","");
            lastCheckinDate = (d !== "") ?  new Date(parseInt(d)) : "";
            lastCheckinPhoto = configGet("lastCheckinPhoto","")
            lastCheckinId = configGet("lastCheckinId", "")


        } catch (e) {
            console.log("exception: configGet" + e)
        }



        if (accessToken === "") {
            auth_refresh()
        }

    }

    function saveCover() {
        console.log("saving last cover to database...")
        try {
            configSet("lastCheckinDate", lastCheckinDate.getTime());
            configSet("lastCheckinPhoto", lastCheckinPhoto);
            configSet("lastCheckin", lastCheckin);
            configSet("lastCheckinId", lastCheckinId);
        } catch (e) {
            console.log("exception: configGet" + e)
        }
    }

    onAccessTokenChanged: {
        console.log("access token changed ! " + accessToken)
        try {
            configSet("accessToken", accessToken)
        } catch (e) {
            console.log("exception: configSet()" + e);
        }
        nearbyVenues();

    }

    function auth_refresh() {
        webview.url =  "https://foursquare.com/oauth2/authenticate?client_id="+clientID+"&response_type=token&redirect_uri=http://www.rar.cz/4sq-sailfish/&display=touch"
        data.visible = true;
    }


    WebView {
        id: webview
        anchors.fill: parent;

        onLoadingChanged: {
            console.log("webview"  + loading)
            if (loading) {
                countLoading++;

            } else {
                countLoading--;

                var str = url.toString();
                var i = str.indexOf("access_token", 0)
                if (i > 0) {
                    var t = str.substr(i+13,str.length)
                    accessToken = t;
                    data.visible = false;
                } else {
                    if (str.indexOf("foursquare.com",0) <= 0) {
                        console.log("authentication error")
                        auth_refresh();
                    } else {
                        console.log("web page of foursquare.com")
                    }
                }

            }
        }

        BusyIndicator {
            id: webviewBusyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            visible: webview.loading;
            running: true;
        }

    }

    function nearbyVenues() {
        if (posReady) {
            nearbyVenues_fetch();
            requestNearbyVenues = false;
            posReady = false;
        } else {
            requestNearbyVenues = true;
        }
    }

    function nearbyVenues_fetch() {
        requestNearbyVenues = false;
        var source = "https://api.foursquare.com/v2/venues/search"
        var params = "oauth_token=" + accessToken+"&ll="+lat+","+lon+"&intent=checkin" + "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function venuesCategories() {
        var source = "https://api.foursquare.com/v2/venues/categories"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function addVenue(venueName, cid, address,crossStreet, city, state, zip, phone, twitter, description, url) {
        var source = "https://api.foursquare.com/v2/venues/add"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale + "&name="+encodeURIComponent(venueName);
        if (address.length > 0) {
            params += "&address="+encodeURIComponent(address)
        }
        if (crossStreet.length > 0) {
            params += "&crossStreet="+encodeURIComponent(crossStreet)
        }
        if (city.length > 0) {
            params += "&city"+encodeURIComponent(city)
        }
        if (state.length > 0) {
            params += "&state="+encodeURIComponent(state)
        }
        if (zip.length > 0) {
            params += "&zip="+encodeURIComponent(zip)
        }
        if (phone.length > 0) {
            params += "&phone="+encodeURIComponent(phone)
        }
        if (twitter.length > 0) {
            params += "&twitter="+encodeURIComponent(twitter)
        }
        params += "&ll=" + lat + "," + lon
        if (cid.length > 0) {
            params += "&primaryCategoryId="+encodeURIComponent(cid)
        }
        if (description.length > 0) {
            params += "&description="+encodeURIComponent(description)
        }
        if (url.length > 0) {
            params += "&url="+encodeURIComponent(url)
        }

        //        source = "http://pcmlich.fit.vutbr.cz/venueAdd.json"

        foursquareDownload(source, params, "POST");
    }

    function likeCheckin(checkin_id, value) {
        var source = "https://api.foursquare.com/v2/checkins/" + checkin_id + "/like"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale + "&set=" + (value ? "1" : "0");
        foursquareDownload(source, params, "POST");
    }

    function likeVenue(venue_id, value) {
        var source = "https://api.foursquare.com/v2/venues/" + venue_id+"/like"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale + "&set=" + (value ? "1" : "0");
        console.log("FIXME likeVenue " + venue_id + " " + value)
//        foursquareDownload(source, params, "POST");
    }

    function likeTip(tip_id, value) {
        var source = "https://api.foursquare.com/v2/tips/" + tip_id + "/like"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale + "&set=" + (value ? "1" : "0");

        foursquareDownload(source, params, "POST");
    }


    function badges(uid) {
        var source = "https://api.foursquare.com/v2/users/"+uid+"/badges"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");

    }

    function profile(uid) {
        var source = "https://api.foursquare.com/v2/users/" + uid
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function friends(uid) {
        var source = "https://api.foursquare.com/v2/users/" + uid + "/friends"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function removeFriend(uid) {
        var source = "https://api.foursquare.com/v2/users/" + uid + "/unfriend"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        //foursquareDownload(source, params, "POST");
        console.log ("remove friend", uid)
    }

    function search(query) {
        var source = "https://api.foursquare.com/v2/venues/search"
        var params = "oauth_token=" + accessToken+"&ll="+lat+","+lon+"&intent=checkin" + "&v="+foursquare_api_version + "&locale="+locale
                +"&query="+encodeURIComponent(query);
        foursquareDownload(source, params, "GET");
    }

    function recentCheckins() {
        var source = "https://api.foursquare.com/v2/checkins/recent"
        var params = "oauth_token=" + accessToken + "&v=" +foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function checkinHistory(uid) {
        var source = "https://api.foursquare.com/v2/users/"+uid+"/checkins"
        var params = "oauth_token=" + accessToken + "&v=" +foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function notifications() {
        var source = "https://api.foursquare.com/v2/updates/notifications"
        var params = "oauth_token=" + accessToken + "&v=" +foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function notificationsMarkAsRead(timestamp) {
        var source = "https://api.foursquare.com/v2/updates/marknotificationsread"
        var params = "oauth_token=" + accessToken + "&v=" +foursquare_api_version + "&locale="+locale + "&highWatermark=" + timestamp
        foursquareDownload(source, params, "POST");
    }

    function addEvent(venue_id,startAt, endAt, name)    {
        var source = "https://api.foursquare.com/v2/events/add"
        var params = "oauth_token=" + accessToken + "&v=" +foursquare_api_version + "&locale="+locale
                + "&venueId=" + venue_id
                + "&startAt="+ startAt
                + "&endAt=" + endAt
                + "&name=" + encodeURIComponent(name)
        foursquareDownload(source, params, "POST");
    }

    function venueTips(vid) {
        var source = "https://api.foursquare.com/v2/venues/" + vid + "/tips"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale + "&sort=recent";
        foursquareDownload(source, params, "GET");
    }

    function tips(uid) {
        var source = "https://api.foursquare.com/v2/users/" + uid + "/tips"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale + "&sort=recent";
        foursquareDownload(source, params, "GET");
    }


    function leaderboard() {
        var source = "https://api.foursquare.com/v2/users/leaderboard";
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function lists (uid) {
        var source = "https://api.foursquare.com/v2/users/" + uid + "/lists"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function venueListed(vid) {
        var source = "https://api.foursquare.com/v2/venues/" + vid + "/listed"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
    }

    function addList(name, description) {
        var source = "https://api.foursquare.com/v2/lists/add"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale
                + "&name=" + name + "&description=" + description;
        foursquareDownload(source, params, "POST");
    }

    function editList(lid, name, description) {
        var source = "https://api.foursquare.com/v2/lists/" + lid + "/update"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale
                + "&name=" + name + "&description=" + description;
        foursquareDownload(source, params, "POST");
    }

    function listDetails(lid) {
        var source = "https://api.foursquare.com/v2/lists/" + lid
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale
        foursquareDownload(source, params, "GET");
    }

    function photos(uid) {
        var source = "https://api.foursquare.com/v2/users/"+uid+"/photos";
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale
        foursquareDownload(source, params, "GET");
    }


    function venuePhotos(vid) {
        var source = "https://api.foursquare.com/v2/venues/"+vid+"/photos";
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale
        foursquareDownload(source, params, "GET");
    }

    function mayorships(uid) {
        var source = "https://api.foursquare.com/v2/users/"+uid+"/mayorships";
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version +
                "&locale="+locale
        foursquareDownload(source, params, "GET");
    }

    function checkin(vid, event, shout, twitter, facebook) {
        var source = "https://api.foursquare.com/v2/checkins/add";
        var params = "oauth_token=" + accessToken + "&v="+foursquare_api_version + "&locale="+locale + "&venueId=" + vid + "&ll=" + lat + "," + lon;

        if ( (event !== undefined) && (event.length > 0)) {
            params += "&eventId="+encodeURIComponent(event)
        }

        if ( (shout !== undefined) && (shout.length > 0)) {
            params += "&shout=" + encodeURIComponent(shout)
        }

        params += "&broadcast=public";

        if (twitter !== undefined && twitter === true) {
            params += ",twitter";
        }

        if (facebook !== undefined && facebook === true) {
            params += ",facebook";
        }

        console.log(source + "?"+params)
        // FIXME
        //        source = "http://pcmlich.fit.vutbr.cz/checkin.json"

        foursquareDownload(source, params, "POST");

    }

    function foursquareDownload(source, params, method) {
        console.log(method + ": " + source + "?" + params)

        var array, item, i, j, data, user;
        var empty_category_icon = {'prefix': "https://foursquare.com/img/categories_v2/none_", "suffix":".png"};

        var http = new XMLHttpRequest()
        http.open(method, source+"?"+params, true);
        http.onreadystatechange = function() {
            //            console.log("http.status: " + http.readyState + " " + http.status + " " + http.statusText)
            var maxValue = 0;

            if (http.readyState === XMLHttpRequest.DONE) {
                countLoading = Math.max(countLoading-1, 0);
                if (http.status === 200) {
                    try{
                        var result = http.responseText;
                        var resultObject = JSON.parse(result)
                        if (resultObject.meta.code >= 400 && resultObject.meta.code < 500) {
                            accessToken = "";
                            return;
                        }

                        if (resultObject.notifications[0].item !== undefined) {
                            var unreadCount = resultObject.notifications[0].item.unreadCount;
                            if (unreadCount > 0) {
                                //% "%n Notifications"
                                notificationPopup.show(qsTrId("n-notifications", unreadCount))
                            }
                        }

                        if (resultObject.response.recent !== undefined) {
                            recentCheckinsPage.m.clear();
                            array = resultObject.response.recent;
                            for (i = 0; i < array.length; i++) {
                                item = array[i];
                                if (item.venue !== undefined) {
                                    var uid = item.user.id;
                                    var vid = item.venue.id
                                    var photo = item.user.photo;
                                    var firstName = (item.user.firstName !== undefined) ? item.user.firstName : "";
                                    var lastName = (item.user.lastName !== undefined) ? item.user.lastName : "";
                                    var venueName = (item.venue.name !== undefined) ? item.venue.name : ""
                                    var createdAt = item.createdAt;
                                    var createdDate = new Date(parseInt(createdAt*1000));
                                    var venueId = (item.venue.id !== undefined) ? item.venue.id : 0;

                                    var street = (item.venue.location.address !== undefined) ? item.venue.location.address : "";
                                    var city   = (item.venue.location.city !== undefined) ? item.venue.location.city : "";
                                    var address = (street !== "") ? (street + ", " + city) : city;

                                    var shout = (item.shout !== undefined) ? item.shout : ""

                                    var venue_icon = (item.venue.categories[0] !== undefined) ? item.venue.categories[0].icon : empty_category_icon


                                    data = {
                                        'checkinId' : item.id,
                                        'liked': item.like,
                                        'uid': item.user.id,
                                        'photo': item.user.photo.prefix + "86x86" + item.user.photo.suffix,
                                        'firstName': ((item.user.firstName !== undefined) ? item.user.firstName : ""),
                                        'lastName': ((item.user.lastName !== undefined) ? item.user.lastName : ""),
                                        'createdAt': createdAt,
                                        'createdDate': createdDate,
                                        'updated': (createdAt > lastUpdate),
                                        'address': address,
                                        'shout': shout,
                                        "vid": item.venue.id,
                                        'venueName': ((item.venue.name !== undefined) ? item.venue.name : ""),
                                        'venuePhoto': venue_icon.prefix + "64" + venue_icon.suffix,
                                        'lat': ((item.venue.location.lat !== undefined) ? item.venue.location.lat : 0),
                                        'lon': ((item.venue.location.lng) ? item.venue.location.lng : 0),
                                        'shoutPhoto' : ((item.photos.count > 0 ) && (item.photos.items[0] !== undefined)) ? (item.photos.items[0].prefix + "original" + item.photos.items[0].suffix) : ""
                                    };

                                    recentCheckinsPage.m.append(data)

                                    //                                          maxValue = Math.max(createdAt, maxValue);
                                    //                                          if (createdAt > lastUpdate) {
                                    //                                              event.updateFeed(uid, photo, firstName + " " + lastName, "@ " + venueName, address, createdAt, venueId)
                                    //                                          }

                                    if (i === 0) {
                                        lastCheckinDate = createdDate
                                        lastCheckinPhoto = photo.prefix + "86x86" + photo.suffix;
                                        lastCheckin = firstName + " " + lastName + "\n@ " + venueName
                                        lastCheckinId = item.id;
                                        saveCover();
                                        //                                    console.log("TO COVER: " + lastCheckin + " " + lastCheckinPhoto + " " + lastCheckinDate)
                                    }
                                    //                                          console.log(firstName + " " + lastName + "@ " + venueName + createdDate)
                                    //                                          checkinsModel.append(data);
                                }
                            }
                            lastUpdate = maxValue;
                            configSet("lastUpdate", lastUpdate);
                        }

                        if (resultObject.response.venues !== undefined) {
                            nearbyVeneuesPage.m.clear();
                            array = resultObject.response.venues
                            for (i = 0; i < array.length; i++) {
                                item = array[i];
                                street = (item.location.address !== undefined) ? item.location.address : "";
                                city   = (item.location.city !== undefined) ? item.location.city : "";
                                address = (street !== "") ? (street + ", " + city) : city;
                                photo = (item.categories[0] !== undefined) ? item.categories[0].icon : empty_category_icon;
                                var events = (item.events !== undefined) ? item.events.count : 0;
                                data = {'vid': item.id, 'name': item.name, 'photo_prefix': photo.prefix, 'photo_suffix': photo.suffix, 'address': address, 'distance': item.location.distance,'hereNow': item.hereNow.count,'lat': item.location.lat, 'lon': item.location.lng,'specials_count': item.specials.count,'stats_checkinsCount': item.stats.checkinsCount,'stats_usersCount': item.stats.usersCount,'stats_tipCount': item.stats.tipCount, 'events' : events}
                                nearbyVeneuesPage.m.append(data)
                            }
                        }

                        if (resultObject.response.checkin !== undefined && resultObject.response.checkin.score !== undefined) {
                            checkinResultPage.m.clear()
                            array = resultObject.response.checkin.score.scores
                            for (i = 0; i < array.length; i++) {
                                item = array[i];
                                checkinResultPage.m.append(item)
                            }
                        }

                        if (resultObject.response.checkins !== undefined) {
                            selfCheckinsPage.m.clear();
                            array = resultObject.response.checkins.items;
                            for (i = 0; i < array.length; i++) {
                                item = array[i];
                                if (item.venue !== undefined) {
                                    var venueName = (item.venue.name !== undefined) ? item.venue.name : ""
                                    var createdAt = item.createdAt;
                                    var createdDate = new Date(parseInt(createdAt*1000));
                                    var venueId = (item.venue.id !== undefined) ? item.venue.id : 0;

                                    var street = (item.venue.location.address !== undefined) ? item.venue.location.address : "";
                                    var city   = (item.venue.location.city !== undefined) ? item.venue.location.city : "";
                                    var address = (street !== "") ? (street + ", " + city) : city;
                                    photo = (item.venue.categories[0] !== undefined) ? item.venue.categories[0].icon : empty_category_icon

                                    data = {'vid': venueId, 'name': venueName, 'photo_prefix': photo.prefix, 'photo_suffix': photo.suffix, 'address': address, 'createdAt': createdAt, 'createdDate': createdDate, 'lat': item.venue.location.lat, 'lon': item.venue.location.lng};

                                    //                                    console.log(venueId + "@ " + venueName + " " + createdDate)

                                    selfCheckinsPage.m.append(data)
                                }
                            }
                        }

                        if (resultObject.response.venue !== undefined) {
                            item = resultObject.response.venue;
                            checkinDetailPage.venue_id = item.id
                            checkinDetailPage.venue_name = item.name;
                            street = (item.location.address !== undefined) ? item.location.address : "";
                            city   = (item.location.city !== undefined) ? item.location.city : "";
                            address = (street !== "") ? (street + ", " + city) : city;
                            checkinDetailPage.venue_address = address;
                            checkinDetailPage.lat = item.location.lat
                            checkinDetailPage.lon = item.location.lng

                        }

                        if (resultObject.response.badges !== undefined) {
                            badgesPage.m.clear();
                            array = resultObject.response.badges;
                            for (var i in array) {
                                item = array[i];

                                data = {'photo': item.image.prefix + item.image.sizes[1] + item.image.name, 'size' : item.image.sizes[1], 'name': item.name}
                                badgesPage.m.append(data);
                            }
                        }

                        if (resultObject.response.photos !== undefined) {
                            photosPage.m.clear();
                            array = resultObject.response.photos.items;
                            for (var i in array) {
                                item = array[i];

                                data = {
                                    'photo': item.prefix + "270x270" + item.suffix,
                                    'photo_large': item.prefix + "original" + item.suffix,
                                }
                                photosPage.m.append(data);
                            }
                        }


                        if (resultObject.response.categories !== undefined) {
                            categoriesPage.m.clear()
                            array = resultObject.response.categories ;
                            for (i = 0; i < array.length; i++) {
                                item = array[i];
                                data = {
                                    'cid': item.id,
                                    'icon': item.icon,
                                    'name': item.name,
                                    'subcategories': ((item.categories !== undefined) ? JSON.stringify(item.categories) : "")
                                }
                                categoriesPage.m.append(data)
                            }
                        }

                        if (resultObject.response.notifications !== undefined) {
                            notificationsPage.m.clear()
                            array = resultObject.response.notifications.items;
                            for (i = 0; i < array.length; i++) {
                                item = array[i];
                                notificationsPage.m.append(item)
                            }
                        }

                        if (resultObject.response.user !== undefined) {
                            user = resultObject.response.user;

                            profilePage.friends_count = user.friends.count;
                            profilePage.profile_photo_url = user.photo.prefix + "128x128" + user.photo.suffix;
                            profilePage.user_name = ((user.firstName !== undefined) ? (user.firstName + " ") : "") + ((user.lastName !== undefined) ?  user.lastName : "")
                            profilePage.user_home_city = user.homeCity
                            profilePage.badges_count = user.badges.count;
                            profilePage.tips_count = user.tips.count
                            profilePage.mayorships_count = user.mayorships.count
                            profilePage.checkins_count  = user.checkins.count
                            profilePage.lists_count  = user.lists.count
                            profilePage.photos_count  = user.photos.count
                            profilePage.scores_recent = user.scores.recent
                            profilePage.scores_max = user.scores.max
                            profilePage.notifications_count = (resultObject.notifications[0].item !== undefined) ? resultObject.notifications[0].item.unreadCount : 0 ;

                        }

                        if (resultObject.response.tips !== undefined) {
                            tipsPage.m.clear();
                            array = resultObject.response.tips.items;
                            for (i = 0; i < array.length; ++i) {
                                item = array[i];
                                var uid = item.id;
                                var text = item.text;
                                var date = new Date(parseInt(item.createdAt * 1000));
                                var likesCount = item.likes.count;
                                if (item.venue !== undefined) {
                                    var venueId = item.venue.id
                                    var venueName = item.venue.name
                                    var address = item.venue.location.address !== undefined ?
                                                item.venue.location.address +
                                                (item.venue.location.crossStreet !== undefined ?
                                                     " " :
                                                     ", ") :
                                                "";
                                    var crossStreet = item.venue.location.crossStreet !== undefined ? "(" + item.venue.location.crossStreet + "), " : "";
                                    var city = item.venue.location.city !== undefined ? item.venue.location.city + ", " : "";
                                    var country = item.venue.location.country !== undefined ? item.venue.location.country : "";
                                    var venueAddress = address + crossStreet + city + country;

                                    var venue_icon = (item.venue.categories[0] !== undefined) ? item.venue.categories[0].icon : empty_category_icon

                                    data = {
                                        'tipId': uid,
                                        'tipText': text,
                                        'photo': ((item.photo !== undefined) ? item.photo.prefix + "300x300" + item.photo.suffix : ""),
                                        'date': date,
                                        'liked': item.like,
                                        'venueIdentifier' : venueId,
                                        'tipTitle' : venueName,
                                        'tipTitle2' : venueAddress,
                                        'tipIcon': venue_icon.prefix + "64" + venue_icon.suffix,
                                    };
                                } else { // if we are asking for tips asociated with venue
                                    data = {
                                        'tipId': uid,
                                        'tipText': text,
                                        'photo': ((item.photo !== undefined) ? item.photo.prefix + "300x300" + item.photo.suffix : ""),
                                        'date': date,
                                        'liked': item.like,
                                        'tipIcon': item.user.photo.prefix + "86x86" + item.user.photo.suffix,
                                        'tipTitle': ((item.user.firstName !== undefined) ? item.user.firstName : "") + " " + ((item.user.lastName !== undefined) ? item.user.lastName : ""),
                                        'tipTitle2': ""

                                    }
                                }

                                tipsPage.m.append(data);
                            }
                        }

                        if (resultObject.response.friends !== undefined) {
                            friendPage.m.clear();
                            array = resultObject.response.friends.items;
                            for (i = 0; i < array.length; ++i) {
                                item = array[i];
                                var uid = item.id;
                                var photo = item.photo;
                                var first_name = (item.firstName !== undefined) ? item.firstName : "";
                                var last_name = (item.lastName !== undefined) ? item.lastName : "";
                                var home_city   = (item.homeCity !== undefined) ? item.homeCity : "";
                                var tips_count = item.tips.count;
                                var contact = item.contact;

                                data = {
                                    'userId': uid,
                                    'photo': photo.prefix + "86x86" + photo.suffix,
                                    'name': first_name + " " + last_name,
                                    'homeCity': home_city,
                                    'tipsCount': tips_count,
                                    'contact': contact
                                };
                                friendPage.m.append(data);
                            }
                        }

                        if (resultObject.response.leaderboard !== undefined) {
                            leaderboardPage.m.clear();
                            array = resultObject.response.leaderboard.items;
                            for (i = 0; i < array.length; ++i) {
                                item = array[i];
                                var user = item.user;
                                var uid = user.id;
                                var first_name = (user.firstName !== undefined) ? user.firstName : "";
                                var last_name = (user.lastName !== undefined) ? user.lastName : "";
                                var photo = user.photo;
                                var checkins_count = item.scores.checkinsCount;
                                var score_max = item.scores.max;
                                var score_recent = item.scores.recent;
                                var rank = item.rank;
                                data = {
                                    'uid': uid,
                                    'photo': photo.prefix + "86x86" + photo.suffix,
                                    'name': first_name + " " + last_name,
                                    'score_max': score_max,
                                    'checkins_count' : checkins_count,
                                    'score_recent': score_recent,
                                    'rank': rank
                                };
                                leaderboardPage.m.append(data);
                            }
                        }
                        if (resultObject.response.lists !== undefined) {
                            listsPage.m.clear();
                            array = resultObject.response.lists.groups;
                            for (i = 0; i < array.length; i++) {
                                var group = array[i]
                                var group_name = group.type
                                for (j = 0; j < group.items.length; j++) {
                                    item = group.items[j];
                                    data = {
                                        'listId': item.id,
                                        'name': item.name,
                                        'group': group.name,
                                        'description': item.description,
                                        'count': item.listItems.count
                                    };
                                    listsPage.m.append(data);
                                }
                            }
                        }

                        if (resultObject.response.list !== undefined) {
                            var found = false;
                            item = resultObject.response.list
                            for (i = 0; i < listsPage.m.count; ++i) {
                                if (item.id === listsPage.m.get(i).listId) {
                                    found = true;
                                    break;
                                }
                            }

                            var listData = {
                                'listId': item.id,
                                'name': item.name,
                                'description': item.description,
                                'count': item.listItems.count
                            }

                            if (found) {
                                listsPage.m.set(i, listData)
                            } else {
                                listsPage.m.append(listData)
                            }

                            if(item.listItems.items !== undefined) {
                                listDetailPage.m.clear()
                                array = item.listItems.items
                                for(i = 0; i < array.length; ++i) {
                                    var listItem = array[i];

                                    var listItemData = {
                                        'liid': listItem.id,
                                        'photo': listItem.photo,
                                        'venue': listItem.venue,
                                        'message': listItem.tip !== undefined ? listItem.tip.text : ""
                                    }
                                    listDetailPage.m.append(listItemData)
                                }
                            }
                        }
                        if (resultObject.response.mayorships !== undefined) {
                            var array = resultObject.response.mayorships.items;
                            mayorshipsPage.m.clear();
                            for (i = 0; i < array.length; i++) {
                                var item = array[i]

                                data = {
                                    'venue': item.venue

                                }

                                mayorshipsPage.m.append(data)
                            }

                        }

                    } catch(e) {
                        console.log("foursquareDownload: parse failed: " + e)
                    }
                    if (countLoading == 0) {
                        last_error = "";
                    }

                    //                              ajaxstatus = "ready"
                } else if (http.status === 401) {
                    console.log("http.status: 401 not authorized")
                    accessToken = "";
                    //% "Unauthorized"
                    last_error = qsTrId("error-not-authorized");

                } else if (http.status === 0){
                    //% "Connection problem"
                    last_error = qsTrId("error-connection-problem"); // http.statusText;
                    countLoading = 0;
                } else {
                    //                              ajaxstatus = "failed"

                    console.log("error in onreadystatechange: " + http.status + " " + http.statusText + ", " + http.getAllResponseHeaders() + "," +http.responseText)
                }
                //                console.log("silent quit (ajaxstatus = ready or failed)")
                //                if (appMode === "silent") {
                //                    Qt.quit();
                //                }

            }

        }
        //        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        countLoading++;
        http.send()
    }

}
