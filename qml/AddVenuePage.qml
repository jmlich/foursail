import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    signal switchToCategoriesPage();

    property string cid;
    property alias category_name: categoryNameLabel.text
    property alias category_icon: categoryIconImage.source

    property alias venueName: venueNameTextfield.text
    property alias address: addressTextfield.text
    property alias crossStreet: crossStreetTextfield.text
    property alias city: cityTextfield.text
    property alias state: stateTextfield.text
    property alias zip: zipTextfield.text
    property alias phone: phoneTextfield.text
    property alias twitter: twitterTextfield.text
    property alias description: descriptionTextfield.text
    property alias url: urlTextfield.text

    canAccept: ( (!venueNameTextfield.errorHighlight) && (cid !== ""))

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
                id: venueNameTextfield
                width: parent.width
                validator: RegExpValidator { regExp: /^.{3,}$/ }
                placeholderText: qsTr("Venue name")
            }

            BackgroundItem {

                Image {
                    id: categoryIconImage
                    width: 64;
                    height: 64;
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.rightMargin: Theme.paddingMedium
                }

                Label {
                    id: categoryNameLabel;
                    anchors.left: categoryIconImage.right
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
                id: addressTextfield
                width: parent.width
                placeholderText: qsTr("Address")
            }

            TextField {
                id: crossStreetTextfield
                width: parent.width
                placeholderText: qsTr("Cross street")

            }

            TextField {
                id: cityTextfield
                width: parent.width
                placeholderText: qsTr("City")
            }

            TextField {
                id: stateTextfield
                width: parent.width
                placeholderText: qsTr("State")
            }

            TextField {
                id: zipTextfield
                width: parent.width
                placeholderText: qsTr("ZIP")
            }

            TextField {
                id: phoneTextfield
                width: parent.width
                inputMethodHints: Qt.ImhDialableCharactersOnly
                placeholderText: qsTr("phone")
            }

            TextField {
                id: twitterTextfield
                width: parent.width
                placeholderText: qsTr("twitter")
            }

            TextArea {
                id: descriptionTextfield
                width: parent.width
                placeholderText: qsTr("description")
                height: 350
            }

            TextField {
                id: urlTextfield
                width: parent.width
//                validator: RegExpValidator { regExp: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/ }
                placeholderText: qsTr("http://")
            }


        }
    }

}

