import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: page

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
    property real lat
    property real lon
    property real deviceLat
    property real deviceLon



    MapPage {
        id: mapPage;
        lat: page.lat
        lon: page.lon
        deviceLat: page.deviceLat
        deviceLon: page.deviceLon
        targetDragable: true;
        onLatChanged: {
            page.lat = lat;
        }
        onLonChanged: {
            page.lon = lon
        }
    }

    onDeviceLatChanged: {
        mapPage.lat = deviceLat;
        mapPage.lon = deviceLon
    }

    canAccept: (!venueNameTextfield.errorHighlight)

    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: contentItem.childrenRect.height

        Column {

            width: parent.width


            DialogHeader {
                id: dialogHeader;
                //% "Create"
                acceptText: qsTrId("venue-add-accept")
            }


            TextField {
                id: venueNameTextfield
                width: parent.width
                validator: RegExpValidator { regExp: /^.{3,}$/ }
                //% "Name"
                placeholderText: qsTrId("venue-add-name")
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
                    source: "https://foursquare.com/img/categories_v2/none_"+height+".png" // default source

                }

                Label {
                    id: categoryNameLabel;
                    anchors.left: categoryIconImage.right
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    //% "Choose category"
                    text: qsTrId("venue-add-choose-category")
                    color: Theme.primaryColor
                }

                onClicked: {
                    switchToCategoriesPage()

                }

            }

            TextField {
                id: addressTextfield
                width: parent.width
                //% "Address"
                placeholderText: qsTrId("venue-add-address")
            }

            TextField {
                id: crossStreetTextfield
                width: parent.width
                //% "Cross street"
                placeholderText: qsTrId("venue-add-cross-street")

            }

            TextField {
                id: cityTextfield
                width: parent.width
                //% "City"
                placeholderText: qsTrId("venue-add-city")
            }

            TextField {
                id: stateTextfield
                width: parent.width
                //% "State"
                placeholderText: qsTrId("venue-add-state")
            }

            TextField {
                id: zipTextfield
                width: parent.width
                //% "ZIP"
                placeholderText: qsTrId("venue-add-zip")
            }

            TextField {
                id: phoneTextfield
                width: parent.width
                inputMethodHints: Qt.ImhDialableCharactersOnly
                //% "Phone"
                placeholderText: qsTrId("venue-add-phone")
            }

            TextField {
                id: twitterTextfield
                width: parent.width
                //% "Twitter"
                placeholderText: qsTrId("venue-add-twitter")
            }

            TextArea {
                id: descriptionTextfield
                width: parent.width
                //% "Description"
                placeholderText: qsTrId("venue-add-description")
                height: 350
            }

            TextField {
                id: urlTextfield
                width: parent.width
//                validator: RegExpValidator { regExp: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/ }
                placeholderText: "http://"
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //% "Set position"
                text: qsTrId("venue-add-set-position")
                onClicked:{
                    pageStack.push(mapPage)
                }
            }


        }
    }

}

