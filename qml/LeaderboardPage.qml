import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: listmodel
    property bool loading;

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Leaderboard")
        }
        spacing: 10;

        delegate: BackgroundItem {
            id: delegate

            height: personPhoto.height

            Image {
                id: personPhoto
                source: photo
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingMedium
                width: 86;
                height: 86;
            }

            Column {
                id: infoColumn
                anchors.left: personPhoto.right
                anchors.right: scoresLabel.left
                anchors.verticalCenter: personPhoto.verticalCenter
                anchors.margins: Theme.paddingMedium

                spacing: Theme.paddingSmall

                Label {
                    id: personNameLabel
                    text: name
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Label {
                    id: infoLabel
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: qsTr ("%1 checkins").arg (checkins_count)
                }
            }

            Label {
                id: scoresLabel
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingMedium
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: score_recent
            }

            onClicked: console.log ("Show friend profile " + uid)
        }

        VerticalScrollDecorator {}

    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }

    Label {
        anchors.centerIn: parent;
        visible: !loading && (listmodel.count === 0)
        text: qsTr("Offline")
    }

}





