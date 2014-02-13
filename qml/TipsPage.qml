import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property string uid;

    property alias m: listmodel
    property bool loading;

    signal refresh();

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Tips")
        }
        spacing: 10;

        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh(uid);
            }
        }

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            property string venueId : venueIdentifier
            property string tipId : tipIdentifier

            Item {
                id: tipPhotoItem
                visible: tipPhoto.source != ""

                Image {
                    id: tipPhoto

                    source: photo

                    anchors.left: parent.left;
                    anchors.top: parent.top;
                    anchors.margins: Theme.paddingMedium

                    width: 86;
                    height: 86;
                }
            }

            Label {
                id: venueNameLabel

                anchors.top: parent.top
                anchors.left: tipPhotoItem.right
                anchors.leftMargin: 10

                textFormat: Text.RichText
                font.bold: true
                text: "<style type='text/css'>a:link{color:"+Theme.primaryColor+"; text-decoration: none;} a:visited{color:"+Theme.primaryColor+"}</style> <a href=\"venue\">" + venueName + "</a>"
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                onLinkActivated: {
                    if (link == "venue") {
                        console.log ("open venue")
                    }
                }
            }

            Label {
                id: venueAddressLabel

                anchors.left: tipPhotoItem.right
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.top: venueNameLabel.bottom
                verticalAlignment: Text.AlignBottom
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeTiny
                elide: Text.ElideRight

                text: venueAddress
            }

            Label {
                id: tipLabel

                anchors.top: venueAddressLabel.bottom
                anchors.left: tipPhotoItem.right
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                text: tipText
                wrapMode: Text.Wrap
            }

            Label {
                id: dateLabel

                anchors.top: tipLabel.bottom
                anchors.left: tipPhotoItem.right
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeTiny
                text: F.formatDate(date)
            }


            onClicked: console.log (venueId, tipId)
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





