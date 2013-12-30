.pragma library

function formatDate(date) {
    var t1 = date.getTime();
    var t2 = new Date().getTime();

    var seconds = Math.floor((Math.abs(t1-t2)/ 1000));


    if (isNaN(seconds)) {
        return ""
    }

//        console.log("seconds "  + seconds )

    var interval = Math.floor(seconds / 31536000);

    if (interval >= 1) {
        return qsTr("%1 years ago").arg(interval);
    }
    interval = Math.floor(seconds / 2592000);
    if (interval >= 1) {
        return qsTr("%1 months ago").arg(interval);
    }
    interval = Math.floor(seconds / 86400);
    if (interval >= 1) {
        return qsTr("%1 days ago").arg(interval);
    }
    interval = Math.floor(seconds / 3600);
    if (interval >= 1) {
        return qsTr("%1 hours ago").arg(interval);
    }
    interval = Math.floor(seconds / 60);
    if (interval >= 1) {
        return qsTr("%1 minutes ago").arg(interval);
    }
    return qsTr("%1 seconds ago").arg(Math.floor(seconds));

}

var earth_radius = 6371000;

function rad2deg (rad) {
    return (180*rad)/Math.PI;
}

function deg2rad (deg) {
    return (deg/180)*Math.PI;
}


function formatDistance(d) {
    if (! d) {
        return "0"
    }

    if (d >= 1000) {
        return Math.round(d / 1000.0) + " km"
    } else if (d >= 100) {
        return Math.round(d) + " m"
    } else {
        return d.toFixed(1) + " m"
    }
}

function formatBearing(b) {
    return Math.round(b) + "°"
}

function formatCoordinate(lat, lon, c) {
    return getLat(lat, c) + " " + getLon(lon, c)
}

function getDM(l) {
    var out = Array(3);
    out[0] = (l > 0) ? 1 : -1
    l = out[0] * l
    out[1] = ("00" + Math.floor(l)).substr(-3, 3)
    out[2] = ("00" + ((l - Math.floor(l)) * 60).toFixed(3)).substr(-6, 6)
    return out
}

function getValueFromDM(sign, deg, min) {
    return sign*(deg + (min/60))
}

function getLat(lat, settings) {
    var l = Math.abs(lat)
    var c = "S";
    if (lat > 0) {
        c = "N"
    }
    if (settings.coordinateFormat === "D") {
        return c + " " + l.toFixed(5) + "°"
    } else if (settings.coordinateFormat === "DMS") {
        var mxt = (l - Math.floor(l)) * 60
        var s = (mxt - Math.floor(mxt)) * 60
        return c + " "+ Math.floor(l) + "° " + Math.floor(mxt) + "' " + Math.floor(s) + "''"
    } else {
        return c + " " + Math.floor(l) + "° " + ((l - Math.floor(l)) * 60).toFixed(3) + "'"
    }
}

function getLon(lon, settings) {
    var l = Math.abs(lon)
    var c = "W";
    if (lon > 0) {
        c = "E"
    }
    if (settings.coordinateFormat === "D") {
        return c + " " + l.toFixed(5) + "°"
    } else if (settings.coordinateFormat === "DMS") {
        var mxt = (l - Math.floor(l)) * 60
        var s = (mxt - Math.floor(mxt)) * 60
        return c + " "+ Math.floor(l) + "° " + Math.floor(mxt) + "' " + Math.floor(s) + "''"
    } else {
        return c + " " + Math.floor(l) + "° " + ((l - Math.floor(l)) * 60).toFixed(3) + "'"
    }
}

function getMapTile(url, x, y, zoom) {
    return url.replace("%(x)d", x).replace("%(y)d", y).replace("%(zoom)d", zoom);
}

function getBearingTo(lat, lon, tlat, tlon) {
    var lat1 = lat * (Math.PI/180.0);
    var lat2 = tlat * (Math.PI/180.0);

    var dlon = (tlon - lon) * (Math.PI/180.0);
    var y = Math.sin(dlon) * Math.cos(lat2);
    var x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dlon);
    return (360 + (Math.atan2(y, x)) * (180.0/Math.PI)) % 360;
}

function getDistanceTo(lat, lon, tlat, tlon) {
    var dlat = Math.pow(Math.sin((tlat-lat) * (Math.PI/180.0) / 2), 2)
    var dlon = Math.pow(Math.sin((tlon-lon) * (Math.PI/180.0) / 2), 2)
    var a = dlat + Math.cos(lat * (Math.PI/180.0)) * Math.cos(tlat * (Math.PI/180.0)) * dlon;
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return 6371000.0 * c;
}

function lineIntersection(Ax, Ay, Bx, By, Cx, Cy, Dx, Dy) {

    //  Fail if either line is undefined.
    if (Ax===Bx && Ay===By || Cx===Dx && Cy===Dy) return false;

    //  Fail if the segments share an end-point.
    if (Ax===Cx && Ay===Cy || Bx===Cx && By===Cy
            ||  Ax===Dx && Ay===Dy || Bx===Dx && By===Dy) {
        return false; }

    //  (1) Translate the system so that point A is on the origin.
    Bx-=Ax; By-=Ay;
    Cx-=Ax; Cy-=Ay;
    Dx-=Ax; Dy-=Ay;

    //  Discover the length of segment A-B.
    var distAB = Math.sqrt(Bx*Bx+By*By);

    //  (2) Rotate the system so that point B is on the positive X axis.
    var theCos=Bx/distAB;
    var theSin=By/distAB;
    var newX=Cx*theCos+Cy*theSin;
    Cy  =Cy*theCos-Cx*theSin; Cx=newX;
    newX=Dx*theCos+Dy*theSin;
    Dy  =Dy*theCos-Dx*theSin; Dx=newX;

    //  Fail if segment C-D doesn't cross line A-B.
    if (Cy<0. && Dy<0. || Cy>=0. && Dy>=0.) return false;

    //  (3) Discover the position of the intersection point along line A-B.
    var ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);

    //  Fail if segment C-D crosses line A-B outside of segment A-B.
    if (ABpos<0. || ABpos>distAB) return false;

    //  (4) Apply the discovered position to line A-B in the original coordinate system.
    var X=Ax+ABpos*theCos;
    var Y=Ay+ABpos*theSin;

    //  Success.
    return true;

}

function getCoordByDistanceBearing(lat, lon, bear, dist) {

    var lat1 = deg2rad(lat);
    var lon1 = deg2rad(lon);
    var brng = deg2rad(bear);
    var d = dist/earth_radius;  // uhlova vzdalenost

    var dlat = d * Math.cos ( brng );
    if (Math.abs(dlat) < 1E-10) {
        dlat = 0;
    }

    var lat2 = lat1 + dlat;
    var dphi = Math.log(Math.tan(lat2/2+Math.PI/4)/Math.tan(lat1/2+Math.PI/4));


    var q = (isFinite(dlat/dphi)) ? dlat/dphi : Math.cos(lat1);  // E-W line gives dPhi=0

    var dLon = d*Math.sin(brng)/q;

    if (Math.abs(lat2) > Math.PI/2) {
        lat2 = (lat2 > 0) ? Math.PI-lat2 : -Math.PI-lat2;
    }


    var lon2 = (lon1+dLon+Math.PI)%(2*Math.PI) - Math.PI;

    return {lat: rad2deg(lat2),lon: rad2deg(lon2)};

}



String.prototype.trunc =
        function(n,useWordBoundary){
            var toLong = this.length>n,
                    s_ = toLong ? this.substr(0,n-1) : this;
            s_ = useWordBoundary && toLong ? s_.substr(0,s_.lastIndexOf(' ')) : s_;
            return  toLong ? s_ +'...' : s_;
        };
