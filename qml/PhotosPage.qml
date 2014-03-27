import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page

    property alias m: model
    property bool loading;
    property string last_error;

    signal showPhotoDetail(string addr);

    ListModel {
        id: model;
    }


    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (model.count === 0)
        running: visible;
    }

    SilicaGridView {
        id: gridView
        model: model;
        anchors.fill: parent;

        cellWidth: ( page.width ) /2
        cellHeight: cellWidth;
        header: PageHeader {
            //% "Photos"
            title: qsTrId("photos-title")
        }


        ViewPlaceholder {
            enabled: !loading && (model.count === 0)
            //% "List of photos is empty"
            text: (last_error !== "") ? last_error : qsTrId("photos-empty")
        }

        delegate: BackgroundItem {
            id: delegate
            clip: true;

//            width:  ( page.width - 2* Theme.paddingMedium) /3
//            height: badgeIcon.height + badgeName.paintedHeight + 3* Theme.paddingMedium;
            width: gridView.cellWidth
            height: gridView.cellHeight

            Image {
                source: "./images/icon-m-common-camera.png"
                width: 128;
                height: 128
                anchors.centerIn: photoItem
                visible: (photoItem.state !== Image.Ready)
            }

            Image {
                id: photoItem

                anchors.top: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter
                width: gridView.cellWidth
                height: gridView.cellWidth

                source: photo;
                fillMode: Image.PreserveAspectCrop
                opacity: delegate.highlighted ? 0.5 : 1;
            }


            onClicked: {
                showPhotoDetail(photo_large);
            }

        }
        VerticalScrollDecorator {}
    }


}





