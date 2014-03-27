import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page

    property alias m: model

    ListModel {
        id: model;
    }


    BusyIndicator {
        anchors.centerIn: parent;
        visible: model.count === 0;
        running: visible;
    }

    SilicaListView {
        id: listView
        model: model
        anchors.fill: parent
        header: PageHeader {
            //% "Checkin"
            title: qsTrId("checkin-result-title")
        }
        spacing: Theme.paddingMedium;

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            Image {
                id: scoreIcon
                source: icon
                anchors.left: parent.left;
                anchors.top: parent.top;
                anchors.topMargin: Theme.paddingSmall
                anchors.leftMargin: Theme.paddingMedium;
                anchors.rightMargin: Theme.paddingMedium
                width: 22
                height: 22
                fillMode: Image.PreserveAspectFit

            }

            Label {
                id: scoreText
                anchors.top: parent.top;
                anchors.left: scoreIcon.right
                anchors.right: scoreValue.left
                anchors.leftMargin: Theme.paddingMedium;
                anchors.rightMargin: Theme.paddingMedium
                text: message
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap
            }

            Label {
                id: scoreValue
                anchors.top: parent.top;
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium;
                anchors.rightMargin: Theme.paddingMedium
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                text: points
                wrapMode: Text.Wrap

            }

//            onClicked: console.log("Clicked " + index)
        }
        VerticalScrollDecorator {}
    }

}





