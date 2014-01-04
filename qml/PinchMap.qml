import QtQuick 2.0
import "functions.js" as F

Rectangle {
    id: pinchmap;
    property bool mapTileVisible:true;
    property bool airspaceVisible: true;

    property int zoomLevel: 15;
    property int oldZoomLevel: 99
    property int maxZoomLevel: 17;
    property int minZoomLevel: 2;
    property int minZoomLevelShowGeocaches: 9;
    property int tileSize: 256;
    property int cornerTileX: 32;
    property int cornerTileY: 32;
    property int numTilesX: Math.ceil(width/tileSize) + 2;
    property int numTilesY: Math.ceil(height/tileSize) + 2;
    property int maxTileNo: Math.pow(2, zoomLevel) - 1;
    property bool showTargetIndicator: true;
    property double targetLat
    property double targetLon

    property bool mapDisabled: false; // tiles should be visible by default

    property bool showPositionError: true
    property bool showCurrentPosition: true;
    property bool currentPositionValid: false;
    property double currentPositionLat
    property double currentPositionLon
    property double currentPositionAzimuth: 0;
    property double currentPositionError: 0;
    property double currentPositionSpeed: 0;
    property double currentPositionAltitude: 0;

    property bool rotationEnabled: false

    property bool pageActive: true;

    onTargetLatChanged: { latitude = targetLat;  }
    onTargetLonChanged: { longitude = targetLon; }

    property double latitude;//: FlightData.configGet("currentPositionLat", 49.803575)
    property double longitude;//: FlightData.configGet("currentPositionLon", 15.475555)

    property variant scaleBarLength: getScaleBarLength(latitude);

    property alias angle: rot.angle

    property string remoteUrl: "http://a.tile.openstreetmap.org/%(zoom)d/%(x)d/%(y)d.png";
    property string localUrl: "~/Maps/OSM/%(zoom)d/%(x)d/%(y)d.png"

    property int earthRadius: 6371000

    property bool needsUpdate: false;


    signal pannedManually

    transform: Rotation {
        angle: 0
        origin.x: pinchmap.width/2
        origin.y: pinchmap.height/2
        id: rot
    }

    onMaxZoomLevelChanged: {
        if (pinchmap.maxZoomLevel < pinchmap.zoomLevel) {
            setZoomLevel(maxZoomLevel);
        }
    }

    onPageActiveChanged:  {
        if (pageActive && needsUpdate) {
            needsUpdate = false;
            pinchmap.setCenterLatLon(pinchmap.latitude, pinchmap.longitude);
        }
    }
    
    onWidthChanged: {
        if (!pageActive) {
            needsUpdate = true;
        } else {
            pinchmap.setCenterLatLon(pinchmap.latitude, pinchmap.longitude);
        }
    }

    onHeightChanged: {
        if (!pageActive) {
            needsUpdate = true;
        } else {
            pinchmap.setCenterLatLon(pinchmap.latitude, pinchmap.longitude);
        }
    }

    onMapTileVisibleChanged: {
        if (!pageActive) {
            needsUpdate = true;
        }
    }
    onAirspaceVisibleChanged: {
        if (!pageActive) {
            needsUpdate = true;
        }
    }


    function setZoomLevel(z) {
        setZoomLevelPoint(z, pinchmap.width/2, pinchmap.height/2);
    }

    function zoomIn() {
        setZoomLevel(pinchmap.zoomLevel + 1)
    }

    function zoomOut() {
        setZoomLevel(pinchmap.zoomLevel - 1)
    }

    function setZoomLevelPoint(z, x, y) {
        if (z === zoomLevel) {
            return;
        }
        if (z < pinchmap.minZoomLevel || z > pinchmap.maxZoomLevel) {
            return;
        }
        var p = getCoordFromScreenpoint(x, y);
        zoomLevel = z;
        setCoord(p, x, y);
    }

    function pan(dx, dy) {
        map.offsetX -= dx;
        map.offsetY -= dy;
    }

    function panEnd() {
        var changed = false;
        var threshold = pinchmap.tileSize;

        while (map.offsetX < -threshold) {
            map.offsetX += threshold;
            cornerTileX += 1;
            changed = true;
        }
        while (map.offsetX > threshold) {
            map.offsetX -= threshold;
            cornerTileX -= 1;
            changed = true;
        }

        while (map.offsetY < -threshold) {
            map.offsetY += threshold;
            cornerTileY += 1;
            changed = true;
        }
        while (map.offsetY > threshold) {
            map.offsetY -= threshold;
            cornerTileY -= 1;
            changed = true;
        }
        updateCenter();
    }

    function updateCenter() {
        var l = getCenter()
        longitude = l[1]
        latitude = l[0]
//        updateGeocaches();
    }

    function requestUpdate() {
        var start = getCoordFromScreenpoint(0,0)
        var end = getCoordFromScreenpoint(pinchmap.width,pinchmap.height)
        //         controller.updateGeocaches(start[0], start[1], end[0], end[1])
        //        updateGeocaches()
        console.debug("Update requested.")
    }

    function requestUpdateDetails() {
        var start = getCoordFromScreenpoint(0,0)
        var end = getCoordFromScreenpoint(pinchmap.width,pinchmap.height)
        //        controller.downloadGeocaches(start[0], start[1], end[0], end[1])
        console.debug("Download requested.")
    }

    function getScaleBarLength(lat) {
        var destlength = width/5;
        var mpp = getMetersPerPixel(lat);
        var guess = mpp * destlength;
        var base = 10 * -Math.floor(Math.log(guess)/Math.log(10) + 0.00001)
        var length_meters = Math.round(guess/base)*base
        var length_pixels = length_meters / mpp
        return [length_pixels, length_meters]
    }

    function getMetersPerPixel(lat) {
        return Math.cos(lat * Math.PI / 180.0) * 2.0 * Math.PI * earthRadius / (256 * (maxTileNo + 1))
    }

    function deg2rad(deg) {
        return deg * (Math.PI /180.0);
    }

    function deg2num(lat, lon) {
        var rad = deg2rad(lat % 90);
        var n = maxTileNo + 1;
        var xtile = ((lon % 180.0) + 180.0) / 360.0 * n;
        var ytile = (1.0 - Math.log(Math.tan(rad) + (1.0 / Math.cos(rad))) / Math.PI) / 2.0 * n;
        return [xtile, ytile];
    }

    function setLatLon(lat, lon, x, y) {
        var oldCornerTileX = cornerTileX
        var oldCornerTileY = cornerTileY
        var tile = deg2num(lat, lon);
        var cornerTileFloatX = tile[0] + (map.rootX - x) / tileSize // - numTilesX/2.0;
        var cornerTileFloatY = tile[1] + (map.rootY - y) / tileSize // - numTilesY/2.0;
        cornerTileX = Math.floor(cornerTileFloatX);
        cornerTileY = Math.floor(cornerTileFloatY);
        map.offsetX = -(cornerTileFloatX - Math.floor(cornerTileFloatX)) * tileSize;
        map.offsetY = -(cornerTileFloatY - Math.floor(cornerTileFloatY)) * tileSize;
        updateCenter();
    }

    function setCoord(c, x, y) {
        setLatLon(c[0], c[1], x, y);
    }

    function setCenterLatLon(lat, lon) {
        setLatLon(lat, lon, pinchmap.width/2, pinchmap.height/2);
    }

    function setCenterCoord(c) {
        setCenterLatLon(c[0], c[1]);
    }

    function getCoordFromScreenpoint(x, y) {
        var realX = - map.rootX - map.offsetX + x;
        var realY = - map.rootY - map.offsetY + y;
        var realTileX = cornerTileX + realX / tileSize;
        var realTileY = cornerTileY + realY / tileSize;
        return num2deg(realTileX, realTileY);
    }

    function getScreenpointFromCoord(lat, lon) {
        var tile = deg2num(lat, lon)
        var realX = (tile[0] - cornerTileX) * tileSize
        var realY = (tile[1] - cornerTileY) * tileSize
        var x = realX + map.rootX + map.offsetX
        var y = realY + map.rootY + map.offsetY
        return [x, y]
    }

    function getMappointFromCoord(lat, lon) {
        //        console.count()
        var tile = deg2num(lat, lon)
        var realX = (tile[0] - cornerTileX) * tileSize
        var realY = (tile[1] - cornerTileY) * tileSize
        return [realX, realY]
        
    }

    function getCenter() {
        return getCoordFromScreenpoint(pinchmap.width/2, pinchmap.height/2);
    }

    function sinh(aValue) {
        return (Math.pow(Math.E, aValue)-Math.pow(Math.E, -aValue))/2;
    }

    function num2deg(xtile, ytile) {
        var n = Math.pow(2, zoomLevel);
        var lon_deg = xtile / n * 360.0 - 180;
        var lat_rad = Math.atan(sinh(Math.PI * (1 - 2 * ytile / n)));
        var lat_deg = lat_rad * 180.0 / Math.PI;
        return [lat_deg % 90.0, lon_deg % 180.0];
    }

    function tileUrl(tx, ty) {
        if (mapDisabled) {
            return "./images/noimage-disabled.png"
        }

        if (tx < 0 || tx > maxTileNo) {
            return "./images/noimage.png"
        }

        if (ty < 0 || ty > maxTileNo) {
            return "./images/noimage.png"
        }
        //        var local = F.getMapTile(localUrl, tx, ty, zoomLevel);
        var remote = F.getMapTile(remoteUrl, tx, ty, zoomLevel);

        //            if (!file_reader.file_exists(local)) {
        //                console.log ("wget "+remote + " --output-document=" +local )
        //            }
        return remote;
        //        return (file_reader.file_exists(local)) ? local : remote

    }

    function imageStatusToString(status) {
        switch (status) {
        case Image.Ready: return qsTr("Ready");
        case Image.Null: return qsTr("Not Set");
        case Image.Error: return qsTr("Error");
        case Image.Loading: return qsTr("Loading...");
        default: return qsTr("Unknown");
        }
    }


    //    ColorModification {
    //        id: colorModification
    //    }


    Grid {

        id: map;
        columns: numTilesX;
        width: numTilesX * tileSize;
        height: numTilesY * tileSize;
        property int rootX: -(width - parent.width)/2;
        property int rootY: -(height - parent.height)/2;
        property int offsetX: 0;
        property int offsetY: 0;
        x: rootX + offsetX;
        y: rootY + offsetY;


        Repeater {
            id: tiles


            model: (pinchmap.numTilesX * pinchmap.numTilesY);
            Rectangle {
                id: tile
                property alias source: img.source;
                property int tileX: cornerTileX + (index % numTilesX)
                property int tileY: cornerTileY + Math.floor(index / numTilesX)
                Image {
                    visible: (img.visible) && (img.status !== Image.Ready)
                    source: "./images/noimage.png"
                }


                Image {
                    id: img;
                    anchors.fill: parent;
                    // onProgressChanged: { progressBar.p = progress }
                    source: tileUrl(tileX, tileY);
                    visible: mapTileVisible
                }


                width: tileSize;
                height: tileSize;
                color: "#c0c0c0";
            }

        }
    }

    //        Item {
    //            id: waypointDisplayContainer
    //            Repeater {
    //                id: waypointDisplay
    //                delegate: Waypoint {
    //                    coordinate: model.coordinate
    //                    targetPoint: getMappointFromCoord(model.coordinate.lat, model.coordinate.lon)
    //                    verticalSpacing: model.numSimilar
    //                    z: 2000
    //                }
    //            }
    //        }

    Image {
        id: targetIndicator
        source: "./images/target-indicator-cross.png"
        property variant t: getMappointFromCoord(targetLat, targetLon)
        x: map.x + t[0] - width/2
        y: map.y + t[1] - height/2

        visible: showTargetIndicator
        transform: Rotation {
            id: rotationTarget
            origin.x: targetIndicator.width/2
            origin.y: targetIndicator.height/2
        }
    }

    Rectangle {
        id: scaleBar
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.topMargin: 16
        anchors.top: parent.top
        color: "black"
        border.width: 2
        border.color: "white"
        smooth: false
        height: 4
        width: scaleBarLength[0]
    }

    Text {
        text: F.formatDistance(scaleBarLength[1], {'distanceUnit':'m'})
        anchors.horizontalCenter: scaleBar.horizontalCenter
        anchors.top: scaleBar.bottom
        anchors.topMargin: 8
        style: Text.Outline
        styleColor: "white"
        font.pixelSize: 24
    }


    PinchArea {
        id: pincharea;
        anchors.fill: parent;

        property double __oldZoom;


        function calcZoomDelta(p) {
            pinchmap.setZoomLevelPoint(Math.round((Math.log(p.scale)/Math.log(2)) + __oldZoom), p.center.x, p.center.y);
            if (rotationEnabled) {
                rot.angle = p.rotation
            }
            pan(p.previousCenter.x - p.center.x, p.previousCenter.y - p.center.y);
        }

        onPinchStarted: {
            __oldZoom = pinchmap.zoomLevel;
        }

        onPinchUpdated: {
            calcZoomDelta(pinch);
        }

        onPinchFinished: {
            calcZoomDelta(pinch);
        }

        MouseArea {
            id: mousearea;

            property bool __isPanning: false;
            property int __lastX: -1;
            property int __lastY: -1;
            property int __firstX: -1;
            property int __firstY: -1;
            property bool __wasClick: false;
            property int maxClickDistance: 100;

            anchors.fill : parent;
            preventStealing: true;

            onWheel:  {
                if (wheel.angleDelta.y > 0) {
                    setZoomLevelPoint(pinchmap.zoomLevel + 1, wheel.x, wheel.y);
                } else {
                    setZoomLevelPoint(pinchmap.zoomLevel - 1, wheel.x, wheel.y);
                }
            }


            onPressed: {
                pannedManually()
                __isPanning = true;
                __lastX = mouse.x;
                __lastY = mouse.y;
                __firstX = mouse.x;
                __firstY = mouse.y;
                __wasClick = true;
            }

            onReleased: {
                __isPanning = false;
                if (! __wasClick) {
                    panEnd();
                } else {
                    //                var n = mousearea.mapToItem(geocacheDisplayContainer, mouse.x, mouse.y)
                    //                var geocaches = new Array();
                    //                var g;
                    //                while ((g = geocacheDisplayContainer.childAt(n.x, n.y)) != null) {
                    //                    geocaches.push(g);
                    //                    g.visible = false;
                    //                }
                    //                if (geocaches.length == 1) {
                    //                    geocaches[0].visible = true;
                    //                    showAndResetDetailsPage();
                    //                    controller.geocacheSelected(geocaches[0].cache);
                    //                } else if (geocaches.length > 1) {
                    //                    var m = new Array();
                    //                    var i;
                    //                    for (i in geocaches) {
                    //                        console.debug("Found geocache: " + geocaches[i].cache.name);
                    //                        geocaches[i].visible = true;
                    //                        m.push(geocaches[i].cache.title);
                    //                    }
                    //                    // show selection window
                    //                    geocacheSelectionDialog.model = m;
                    //                    geocacheSelectionDialog.fullList = geocaches;
                    //                    geocacheSelectionDialog.open();

                    //                }
                }

            }

            onPositionChanged: {
                if (__isPanning) {
                    var dx = mouse.x - __lastX;
                    var dy = mouse.y - __lastY;
                    pan(-dx, -dy);
                    __lastX = mouse.x;
                    __lastY = mouse.y;
                    /*
                    once the pan threshold is reached, additional checking is unnecessary
                    for the press duration as nothing sets __wasClick back to true
                    */
                    if (__wasClick && Math.pow(mouse.x - __firstX, 2) + Math.pow(mouse.y - __firstY, 2) > maxClickDistance) {
                        __wasClick = false;
                    }
                }
            }

            onCanceled: {
                __isPanning = false;
            }
        }

    }


    //    SelectionDialog {
    //        id: geocacheSelectionDialog
    //        titleText: "Select geocache"
    //        model: []
    //        property variant fullList: []
    //        onAccepted: {
    //            showAndResetDetailsPage();
    //            controller.geocacheSelected(fullList[selectedIndex].cache);
    //        }
    //    }



}