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
            title: qsTr("Checkin")
        }
        spacing: 10;

        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height

            Image {
                id: scoreIcon
                source: icon
                anchors.left: parent.left;
                anchors.top: parent.top;
                anchors.topMargin: 5
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                width: 22
                height: 22
                fillMode: Image.PreserveAspectFit

            }

            Label {
                id: scoreText
                anchors.top: parent.top;
                anchors.left: scoreIcon.right
                anchors.right: scoreValue.left
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                text: message
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap
            }

            Label {
                id: scoreValue
                anchors.top: parent.top;
                anchors.right: parent.right
                anchors.leftMargin: 10;
                anchors.rightMargin: 10
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                text: points
                wrapMode: Text.Wrap

            }

//            onClicked: console.log("Clicked " + index)
        }
        VerticalScrollDecorator {}
    }

}





