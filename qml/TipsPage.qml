import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property string uid;

    property alias m: listmodel
    property bool loading;

//    signal refresh(string uid);

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

//        PullDownMenu {
//            MenuItem {
//                text: qsTr("Refresh")
//                onClicked: refresh(uid);
//            }
//        }

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            property string venueId : venueIdentifier
            property string tipId : tipIdentifier


            Label {
                id: venueNameLabel

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium

                textFormat: Text.RichText
                font.pixelSize: Theme.fontSizeLarge
//                text: "<style type='text/css'>a:link{color:"+Theme.primaryColor+"; text-decoration: none;} a:visited{color:"+Theme.primaryColor+"}</style> <a href=\"venue\">" + venueName + "</a>"
                text: venueName
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                onLinkActivated: {
                    if (link == "venue") {
                        console.log ("open venue")
                    }
                }
            }

            Image {
                id: tipPhotoImage
                anchors.top: venueNameLabel.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium;
                anchors.rightMargin: Theme.paddingMedium
                fillMode: Image.PreserveAspectFit
                source: photo
                visible: (photo !== "")
            }


            Label {

                id: venueAddressLabel

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium
                anchors.top: tipPhotoImage.bottom
                verticalAlignment: Text.AlignBottom
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeTiny
                elide: Text.ElideRight

                text: venueAddress
            }

            Label {
                id: dateLabel

                anchors.top: venueAddressLabel.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium

                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeTiny
                text: F.formatDate(date)
            }

            Label {
                id: tipLabel

                anchors.top: dateLabel.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium

                text: tipText
                wrapMode: Text.Wrap
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




