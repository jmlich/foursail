import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property string uid;

    property alias m: listmodel
    property bool loading;
    property string last_error

    signal likeTip(string tid, bool value)

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        header: PageHeader {
            //% "Tips"
            title: qsTrId("tips-title")
        }
        spacing: Theme.paddingMedium;


        ViewPlaceholder {
            enabled: !loading && (listmodel.count === 0)
            //% "List of tips is empty"
            text: (last_error !== "") ? last_error : qsTrId("tips-empty")
        }

        property Item contextMenu

        delegate: Item {
            id: myListItem
            height: (menuOpen ? listView.contextMenu.height : 0) +  delegate.height;
            width: parent.width
            property bool menuOpen: ((listView.contextMenu  !== null) && (listView.contextMenu.parent === myListItem))

            BackgroundItem {
                id: delegate
                height: contentItem.childrenRect.height
                width: parent.width

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
                    text: tipTitle
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
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
                    wrapMode: Text.WordWrap
                    text: ((tipTitle2 !== "") ? tipTitle2+"\n" : "")
                          + Format.formatDate(date, Formatter.DurationElapsed)
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

                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor;

                    text: tipText
                    wrapMode: Text.Wrap
                }

                onClicked: {

                    if (listView.contextMenu === null) {
                        listView.contextMenu = contextMenuComponent.createObject(listView)
                    }
                    listView.contextMenu.tipId = tipId;
                    listView.contextMenu.liked = liked;

                    listView.contextMenu.show(myListItem);
                }
            }
        }


        Component {
            id: contextMenuComponent
            ContextMenu {
                property string tipId;
                property bool liked;

                MenuItem {
                    text: liked ?
                              //% "Dislike tip"
                              qsTrId("tips-dislike") :
                              //% "Like tip"
                              qsTrId("tips-like")
                    onClicked: {
                        liked = !liked;
                        likeTip(tipId, liked)

                        // projection of like to current listmodel
                        for (var i = 0; i < listmodel.count; i++) {
                            var item = listmodel.get(i);
                            if (item.tipId === tipId) {
                                listmodel.setProperty(i, "liked", liked)
                            }
                        }
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }


}





