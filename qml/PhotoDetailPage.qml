import QtQuick 2.0
import Sailfish.Silica 1.0

import "functions.js" as F

Page {
    id: page
    allowedOrientations: Orientation.All

    property alias addr: imageItem.source


    BusyIndicator {
        anchors.centerIn: parent;
        visible: (imageItem.status !== Image.Ready)
        running: visible;
    }


    SilicaFlickable {
        id: imageFlickable
        anchors.fill: parent;
        clip: true;

        contentWidth: imageContainer.width; contentHeight: imageContainer.height
        onHeightChanged: {
            if (imageItem.status === Image.Ready) {
                imageItem.fitToScreen()
            }
        }


        Item {
            id: imageContainer
            width: Math.max(imageItem.width * imageItem.scale, imageFlickable.width)
            height: Math.max(imageItem.height * imageItem.scale, imageFlickable.height)

            AnimatedImage {
                id: imageItem

                property real prevScale

                function fitToScreen() {
                    scale = Math.min(imageFlickable.width / width, imageFlickable.height / height, 1)
                    pinchArea.minScale = scale
                    prevScale = scale
                }

                anchors.centerIn: parent
                asynchronous: true
                smooth: !imageFlickable.moving
                cache: false
                fillMode: Image.PreserveAspectFit
                // pause the animation when app is in background
                paused: (page.status !== PageStatus.Active) || !Qt.application.active

                onScaleChanged: {
                    if ((width * scale) > imageFlickable.width) {
                        var xoff = (imageFlickable.width / 2 + imageFlickable.contentX) * scale / prevScale;
                        imageFlickable.contentX = xoff - imageFlickable.width / 2
                    }
                    if ((height * scale) > imageFlickable.height) {
                        var yoff = (imageFlickable.height / 2 + imageFlickable.contentY) * scale / prevScale;
                        imageFlickable.contentY = yoff - imageFlickable.height / 2
                    }
                    prevScale = scale
                }

                onStatusChanged: {
                    if ((status === Image.Ready) && (imageItem.width !== 0)) { // The width is 0 when Image.Ready ? Why?
                        fitToScreen()
                        loadedAnimation.start()
                    }
                }
                onWidthChanged: {
                    if ((status === Image.Ready) && (imageItem.width !== 0)) {
                        fitToScreen()
                        loadedAnimation.start()
                    }
                }

                onSourceChanged: {
                    console.log("GET: " + source)
                }

                NumberAnimation {
                    id: loadedAnimation
                    target: imageItem
                    property: "opacity"
                    duration: 250
                    from: 0; to: 1
                    easing.type: Easing.InOutQuad
                }
            }
        }


        PinchArea {
            id: pinchArea

            property real minScale: 1.0
            property real maxScale: 3.0

            anchors.fill: parent
            enabled: true; // (imageItem.status === Image.Ready)
            pinch.target: imageItem
            pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
            pinch.maximumScale: maxScale * 1.5 // when over zoomed

            onPinchFinished: {
                imageFlickable.returnToBounds()
                if (imageItem.scale < pinchArea.minScale) {
                    bounceBackAnimation.to = pinchArea.minScale
                    bounceBackAnimation.start()
                }
                else if (imageItem.scale > pinchArea.maxScale) {
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }

            NumberAnimation {
                id: bounceBackAnimation
                target: imageItem
                duration: 250
                property: "scale"
                from: imageItem.scale
            }
        }

        ScrollDecorator {}

    }



}

