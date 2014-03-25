import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: listmodel
    property bool loading;

    signal refresh();
    signal removeFriend(string uid);
    signal showFriend(string uid)

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Friends")
        }
        spacing: 10;

        property Item contextMenu

        delegate: BackgroundItem {
            id: delegate

            property string uid : userId;

            property bool menuOpen: listView.contextMenu != null &&
                    listView.contextMenu.parent === delegate
            height: menuOpen ?
                listView.contextMenu.height + contentItem.childrenRect.height :
                contentItem.childrenRect.height

            Image {
                id: personPhoto
                source: photo
                anchors.left: parent.left;
                anchors.top: parent.top;
                width: 86;
                height: 86;
            }

            Label {
                id: personNameLabel
                anchors.top: parent.top;
                anchors.left: personPhoto.right
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                text: name
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            Label {
                id: cityLabel
                anchors.top: personNameLabel.bottom;
                anchors.left: personPhoto.right
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: homeCity
            }

            function remove() {
                var idx = index
                remorse.execute(delegate, qsTr ("Removing friend"),
                        function () {
                            removeFriend(uid);
                            listmodel.remove(idx);
                        }, 5000);
            }

            RemorseItem { id: remorse }

            onClicked: {
                showFriend(uid)
            }

            onPressAndHold: {
                listView.currentIndex = index;
                if (!listView.contextMenu)
                    listView.contextMenu = friendContextMenuComponent.createObject()
                listView.contextMenu.show(delegate)
            }
        }

        VerticalScrollDecorator {}

        Component {
            id: friendContextMenuComponent
            ContextMenu {
                MenuItem {
                    text: qsTr ("Remove");
                    onClicked: listView.currentItem.remove();
                }
            }
        }
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





