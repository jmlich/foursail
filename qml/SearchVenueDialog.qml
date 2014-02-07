import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: searchDialog

    property alias searchString: searchTextFiels.text
    property string historyStr;
    signal search(string str);
    signal saveHistory(string str);

    Column {
        anchors.fill: parent;
        DialogHeader {
            title: qsTr("Search")
        }

        SearchField {
            id: searchTextFiels
            width: parent.width
            placeholderText: qsTr("Venue name")
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

    onAccepted: {
        search(searchString);
        searchHistory.insert(0, {"value": searchString})
        searchString = "";


        var arr = []
        for (var i = 0; ((i < searchHistory.count) && (i < 10)); i++) {
            arr.push(searchHistory.get(i).value);
        }
        saveHistory(JSON.stringify(arr));
    }

    ListModel {
        id: searchHistory;
    }


    onHistoryStrChanged: {
        console.log("SearchVenueDialog - search changed")
        if (historyStr !== "") {
            var arr = JSON.parse(historyStr)
            for (var i = 0; i < arr.length; i++) {
                searchHistory.append({"value": arr[i]})

            }

        }
    }

    //    Label {
    //        anchors.centerIn: parent;
    //        text: "not implemented, sorry"
    //        color: Theme.primaryColor
    //    }

}
