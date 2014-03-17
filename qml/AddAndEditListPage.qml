import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog

    canAccept: listNameTextfield.text != ""

    property string listId
    property alias listName: listNameTextfield.text
    property alias listDescription: listDescriptionTextfield.text
    property alias dialogHeaderText: dialogHeader.acceptText

    Column {
        width: parent.width

        DialogHeader {
            id: dialogHeader;
            acceptText: qsTr("Create List")
        }

        TextField {
            id: listNameTextfield
            width: parent.width
            placeholderText: qsTr("List name")
        }

        TextField {
            id: listDescriptionTextfield
            width: parent.width
            placeholderText: qsTr("List's description")
        }
    }
}
