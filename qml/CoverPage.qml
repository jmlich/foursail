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
    property string checkin_id;


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
        anchors.centerIn: parent
        text: qsTr("Loading ...")
    }

    Label {
        visible: (checkinLabel.text === "") && !loading
        anchors.centerIn: parent
        text: qsTr("Offline")
    }



    CoverActionList {
        id: firstCoverActionList
        enabled: (checkinLabel.text !== "")

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: refresh();
        }

        CoverAction {
            iconSource:  "./images/icon-cover-like.png"
            onTriggered: like();
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
            timestampLabel.text = F.formatDate(updateDate)
        }

    }


    Timer {
        id: coverTimer
        interval: 10000
        running: (status === Cover.Active)
        onTriggered: {
            timestampLabel.text = F.formatDate(updateDate)
        }
    }

}


