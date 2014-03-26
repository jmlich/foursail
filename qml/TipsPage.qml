import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property string uid;

    property alias m: listmodel
    property bool loading;
    property string last_error

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
        spacing: Theme.paddingMedium;


        ViewPlaceholder {
            enabled: !loading && (listmodel.count === 0)
            text: (last_error !== "") ? last_error : qsTr("Add a new tip")
        }

//        PullDownMenu {
//            MenuItem {
//                text: qsTr("Refresh")
//                onClicked: refresh(uid);
//            }
//        }

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            property string tipId : tipIdentifier


            Image {
                id: itemIcon
                width: 86
                height: 86
                anchors.margins: Theme.paddingMedium
                source: tipIcon;
            }

            Label {
                id: venueNameLabel

                anchors.top: parent.top
                anchors.left: itemIcon.right
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium

                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                font.pixelSize: Theme.fontSizeLarge
//                text: "<style type='text/css'>a:link{color:"+Theme.primaryColor+"; text-decoration: none;} a:visited{color:"+Theme.primaryColor+"}</style> <a href=\"venue\">" + venueName + "</a>"
                text: tipTitle
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
                anchors.left: itemIcon.right
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium;
                anchors.rightMargin: Theme.paddingMedium
                fillMode: Image.PreserveAspectFit
                source: photo
                visible: (photo !== "")
            }


            Label {

                id: venueAddressLabel

                anchors.left: itemIcon.right
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium
                anchors.top: tipPhotoImage.bottom
                verticalAlignment: Text.AlignBottom
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                text: ((tipTitle2 !== "") ? tipTitle2+"\n" : "") + F.formatDate(date)
            }

//            Label {
//                id: dateLabel

//                anchors.top: venueAddressLabel.bottom
//                anchors.left: itemIcon.right
//                anchors.right: parent.right
//                anchors.leftMargin: Theme.paddingMedium
//                anchors.rightMargin: Theme.paddingMedium

//                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
//                font.pixelSize: Theme.fontSizeSmall
//                wrapMode: Text.WordWrap
//                text: F.formatDate(date)
//            }

            Label {
                id: tipLabel

                anchors.top: venueAddressLabel.bottom
                anchors.left: itemIcon.right
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium

                text: tipText
                wrapMode: Text.Wrap
            }

            onClicked: console.log ("like/dislike tip: " + tipId)  // press and hold?
        }
        VerticalScrollDecorator {}
    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }


}





