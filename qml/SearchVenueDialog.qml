import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: searchDialog

    property alias searchString: searchTextField.text
    property string historyStr;
    signal search(string str);
    signal saveHistory(string str);


    canAccept: (searchTextField.text !== "")


    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: column.height

        Column {
            id: column
            anchors.left: parent.left;
            anchors.right: parent.right
            DialogHeader {
                //% "Search"
                title: qsTrId("search-title")
            }

            SearchField {
                id: searchTextField
                width: parent.width
                //% "Venue name"
                placeholderText: qsTrId("search-venue-name")
                EnterKey.onClicked: {
                    searchDialog.accept()
                }
            }

            Repeater {
                model: searchHistory
                delegate: BackgroundItem {
                    width: parent.width
                    Label {
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.left: parent.left;
                        anchors.right: parent.right;
                        anchors.margins: Theme.paddingMedium;
                        text: value
                        color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }

                    onClicked: searchString = value;
                }

            }

        }
    }

    onAccepted: {
        search(searchString);

        var found = false;

        for (var i = 0; i < searchHistory.count; i++) {
            var item = searchHistory.get(i);
            if (item.value === searchString) {
                found = true;
                break;
            }
        }
        if (!found) {
            searchHistory.insert(0, {"value": searchString})

            var arr = []
            for (var i = 0; ((i < searchHistory.count) && (i < 15)); i++) {
                arr.push(searchHistory.get(i).value);
            }
            saveHistory(JSON.stringify(arr));
        }

        searchString = "";

    }

    ListModel {
        id: searchHistory;
    }


    onHistoryStrChanged: {
        if (historyStr !== "") {
            var arr = JSON.parse(historyStr)
            for (var i = 0; i < arr.length; i++) {
                searchHistory.append({"value": arr[i]})

            }

        }
    }


}
