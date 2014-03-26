import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page

    property alias m: model
    property bool loading;
    property string last_error


    ListModel {
        id: model;
    }


    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (model.count === 0)
        running: visible;
    }

    SilicaGridView {
        id: gridView
        model: model;
        anchors.fill: parent;
        anchors.margins: Theme.paddingMedium

        cellWidth: ( page.width - 2* Theme.paddingMedium) /3
        cellHeight: 1.4*cellWidth
        header: PageHeader {
            title: qsTr("Badges")
        }

        ViewPlaceholder {
            enabled: !loading && (model.count === 0)
            text: (last_error !== "") ? last_error : qsTr("You have no badge")
        }


        delegate: BackgroundItem {
            id: delegate
            clip: true;

//            width:  ( page.width - 2* Theme.paddingMedium) /3
//            height: badgeIcon.height + badgeName.paintedHeight + 3* Theme.paddingMedium;
            width: gridView.cellWidth
            height: gridView.cellHeight

            Image {
                id: badgeIcon

                anchors.topMargin: Theme.paddingMedium
                anchors.top: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter
                width: model.size;
                height: model.size;

                source: photo;
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: badgeName
                anchors.top: badgeIcon.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                anchors.margins: Theme.paddingMedium


                text: name
                wrapMode: Text.Wrap
                color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
            }

        }
        VerticalScrollDecorator {}
    }


}





