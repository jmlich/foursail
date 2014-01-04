import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: searchDialog

    property alias searchString: searchTextFiels.text

    Column {
        anchors.fill: parent;
        DialogHeader {
            title: qsTr("Search")
        }

        SearchField {
            id: searchTextFiels
            width: parent.width
            placeholderText: qsTr("Venue name")
            EnterKey.onClicked: searchDialog.accept()
        }

    }




    //    Label {
    //        anchors.centerIn: parent;
    //        text: "not implemented, sorry"
    //        color: Theme.primaryColor
    //    }

}
