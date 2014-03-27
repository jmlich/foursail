import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog

    canAccept: listNameTextfield.text !== ""

    property string listId
    property alias listName: listNameTextfield.text
    property alias listDescription: listDescriptionTextfield.text
    property alias dialogHeaderText: dialogHeader.acceptText

    Column {
        width: parent.width

        DialogHeader {
            id: dialogHeader;
            acceptText: (listId !== "")
            //% "Edit List"
                        ? qsTrId("lists-edit-accept")
                          //% "Create List"
                        : qsTrId("lists-create-accept")
        }

        TextField {
            id: listNameTextfield
            width: parent.width
            //% "List name"
            placeholderText: qsTrId("lists-create-name")
        }

        TextField {
            id: listDescriptionTextfield
            width: parent.width
            //% "List description"
            placeholderText: qsTrId("lists-create-description")
        }
    }
}
