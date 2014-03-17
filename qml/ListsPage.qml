import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page

    property alias m: listmodel
    property bool loading;

    signal switchToAddAndEditList(string lid, string name, string description)
    signal switchToListDetailPage(string lid, string listName)

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("New list")
                onClicked: switchToAddAndEditList("", "", "")
            }
        }

        header: PageHeader {
            title: qsTr("Lists")
        }

        spacing: Theme.paddingMedium

        property Item contextMenu

        delegate: BackgroundItem {
            id: delegate

            width: parent.width

            property bool menuOpen: listView.contextMenu != null &&
                    listView.contextMenu.parent === delegate
            height: menuOpen ?
                listView.contextMenu.height + 70 :
                70

            property string lid: listId
            property string listName: name
            property string listDescription: description

            Label {
                id: nameLabel

                anchors.left: parent.left
                anchors.right: itemsCountLabel.left
                anchors.verticalCenter: descriptionLabel.text.length === 0 && !menuOpen ?
                    parent.verticalCenter :
                    undefined
                anchors.margins: Theme.paddingMedium

                font.family: Theme.fontFamilyHeading
                font.pixelSize:  Theme.fontSizeMedium
                elide: Text.ElideRight
                color: parent.down ? Theme.highlightColor : Theme.primaryColor

                text: name
            }

            Label {
                id: descriptionLabel

                anchors.left: parent.left
                anchors.right: itemsCountLabel.left
                anchors.top: nameLabel.bottom
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium
                anchors.topMargin: 0

                font.pixelSize:  Theme.fontSizeTiny
                elide: Text.ElideRight
                color: parent.down ? Theme.highlightColor : Theme.primaryColor

                text: description
            }

            Label {
                id: itemsCountLabel
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 10
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                text: count
            }

            onClicked: switchToListDetailPage(delegate.lid, delegate.listName)

            onPressAndHold: {
                listView.currentIndex = index;
                if (!listView.contextMenu)
                    listView.contextMenu = listsContextMenuComponent.createObject()
                listView.contextMenu.show(delegate)
            }
        }

        VerticalScrollDecorator {}

        Component {
            id: listsContextMenuComponent
            ContextMenu {
                MenuItem {
                    text: qsTr ("Edit");
                    onClicked: switchToAddAndEditList(listView.currentItem.lid,
                            listView.currentItem.listName, listView.currentItem.listDescription)
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





