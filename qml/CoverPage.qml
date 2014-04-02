import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

CoverBackground {
    id: cover;
    signal refresh();
    signal like();
    property alias labelText: checkinLabel.text
    property date updateDate
    property alias checkinPhotoSource: checkinPhoto.source
    property bool loading;
    property string last_error;
    property string checkin_id;

    onUpdateDateChanged: {
        timestampLabel.text = Format.formatDate(updateDate, Formatter.DurationElapsed)
    }


    Image {
        id: checkinPhoto
        anchors.top: parent.top
        anchors.margins: Theme.paddingMedium;
        anchors.horizontalCenter: parent.horizontalCenter
        width: 96; height: 96
        fillMode: Image.PreserveAspectFit
    }


    Column {
        anchors {
            top: checkinPhoto.bottom
            left: parent.left;
            right: parent.right
            margins: Theme.paddingMedium;

        }
        Label {
            z: 2
            id: checkinLabel
            anchors.left: parent.left;
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeSmall;
        }

        Label {
            z: 2
            id: timestampLabel
            anchors.left: parent.left;
            anchors.right: parent.right
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }
    }

    Label {
        visible: (checkinLabel.text === "") && loading
        anchors.centerIn: parent;
        color: Theme.secondaryColor;
        width: parent.width - Theme.paddingLarge
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap;
        //% "Loading ..."
        text: qsTrId("cover-loading")
    }

    Label {
        visible: (checkinLabel.text === "") && !loading
        anchors.centerIn: parent;
        color: Theme.secondaryColor;
        width: parent.width - Theme.paddingLarge
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap;
        //% "Nobody of your friends checked in yet"
        text: (last_error !== "") ? last_error : qsTrId("cover-no-checkins")

    }



    CoverActionList {
        id: firstCoverActionList
        enabled: (checkinLabel.text !== "")

        CoverAction {
            iconSource:  "./images/icon-cover-like.png"
            onTriggered: like();
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: refresh();
        }


    }

    CoverActionList {
        enabled: !firstCoverActionList.enabled;

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: refresh();
        }

    }

    onStatusChanged: {
        if (status === Cover.Active) {
            timestampLabel.text = Format.formatDate(updateDate, Formatter.DurationElapsed)
        }

    }


    Timer {
        id: coverTimer
        interval: 10000 // 10 s
        repeat: true
        running: (status === Cover.Active)
        onTriggered: {
            timestampLabel.text = Format.formatDate(updateDate, Formatter.DurationElapsed)
        }
    }

    Timer {
        id: refreshTimer
        interval: 1800000 // 30 * 60 * 1000 ms = 30 minutes
        repeat: true
        running: (status === Cover.Active)
        onTriggered: {
            refresh()
        }
    }

}


