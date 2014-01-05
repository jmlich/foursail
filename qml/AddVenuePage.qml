import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    signal switchToCategoriesPage();

    property string cid;
    property alias category_name: category_name_label.text
    property alias category_icon: categoryIcon.source

    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: contentItem.childrenRect.height

        Column {

            width: parent.width


            DialogHeader {
                id: dialogHeader;
                acceptText: qsTr("Create Venue")
            }


            TextField {
                id: name
                width: parent.width
                placeholderText: qsTr("Venue name")
            }

            BackgroundItem {

                Image {
                    id: categoryIcon
                    width: 64;
                    height: 64;
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.rightMargin: Theme.paddingMedium
                }

                Label {
                    id: category_name_label;
                    anchors.left: categoryIcon.right
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Choose category")
                    color: Theme.primaryColor
                }

                onClicked: {
                    switchToCategoriesPage()

                }

            }

            TextField {
                id: address
                width: parent.width
                placeholderText: qsTr("Address")
            }

            TextField {
                id: crossStreet
                width: parent.width
                placeholderText: qsTr("Cross street")

            }

            TextField {
                id: city
                width: parent.width
                placeholderText: qsTr("City")
            }

            TextField {
                id: state
                width: parent.width
                placeholderText: qsTr("State")
            }

            TextField {
                id: zip
                width: parent.width
                placeholderText: qsTr("ZIP")
            }

            TextField {
                id: phone
                width: parent.width
                placeholderText: qsTr("phone")
            }

            TextField {
                id: twitter
                width: parent.width
                placeholderText: qsTr("twitter")
            }

            TextArea {
                id: description
                width: parent.width
                placeholderText: qsTr("description")
            }

            TextField {
                id: url
                width: parent.width
                placeholderText: qsTr("http://")
            }

            BackgroundItem {

                Label {
                    anchors.centerIn: parent;
                    text: "not implemented, sorry"
                    color: Theme.primaryColor
                }

            }

        }
    }

}

