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
        } catch (e) {
            console.log("exception: configGet" + e)
        }

        if (accessToken === "") {
            auth_refresh()
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

    function likeCheckin(checkin_id) {
        var source = "https://api.foursquare.com/v2/checkins/" + checkin_id + "/like"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale + "&set=1";
        foursquareDownload(source, params, "POST");
    }

    function badges(uid) {
        var source = "https://api.foursquare.com/v2/users/"+uid+"/badges"
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");

    }

    function profile(uid) {
        var source = "https://api.foursquare.com/v2/users/"+uid
        var params = "oauth_token=" + accessToken+ "&v="+foursquare_api_version + "&locale="+locale;
        foursquareDownload(source, params, "GET");
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


    function checkin(vid, shout, twitter, facebook) {
        var source = "https://api.foursquare.com/v2/checkins/add";
        var params = "oauth_token=" + accessToken + "&v="+foursquare_api_version + "&locale="+locale + "&venueId=" + vid + "&ll=" + lat + "," + lon;

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

        var array, item, i, data, user;

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
                        //                        console.log("XXXXXXXXXXXXXXX " + result + "YYYYYYYYYYYYYYYYYYYYY")
                        var resultObject = JSON.parse(result)
                        if (resultObject.meta.code >= 400 && resultObject.meta.code < 500) {
                            accessToken = "";
                            return;
                        }

                        if (resultObject.notifications[0].item !== undefined) {
                            var unreadCount = resultObject.notifications[0].item.unreadCount;
                            if (unreadCount > 0) {
                                notificationPopup.show(qsTr("%1 Notifications").arg(unreadCount))
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

                                    var venue_icon = (item.venue.categories[0] !== undefined) ? item.venue.categories[0].icon : ""


                                    data = {
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
                                photo = (item.categories[0] !== undefined) ? item.categories[0].icon : ""
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
                                    photo = (item.venue.categories[0] !== undefined) ? item.venue.categories[0].icon : ""

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
                            myProfilePage.friends_count = user.friends.count;
                            myProfilePage.profile_photo_url = user.photo.prefix + "128x128" + user.photo.suffix;
                            myProfilePage.user_name = user.firstName + " " + user.lastName + " (" + user.gender + ")"
                            myProfilePage.user_home_city = user.homeCity
                            myProfilePage.checkins_count = user.checkins.count
                            myProfilePage.tips_count = user.tips.count
                        }


                    } catch(e) {
                        console.log("foursquareDownload: parse failed: " + e)
                    }
                    //                              ajaxstatus = "ready"
                } else if (http.status === 401) {
                    console.log("http.status: 401 not authorized")
                    accessToken = "";

                } else if (http.status === 0){
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
