import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page

    property alias m: model
    property alias leaderboard_m: leaderboard_model;
    property alias badges_m: badges_model;
    property alias message: message_text.text
    property alias special_message: special_message_label.text

    ListModel {
        id: model;
    }

    ListModel {
        id: badges_model;
    }

    ListModel {
        id: leaderboard_model;
    }


    BusyIndicator {
        anchors.centerIn: parent;
        visible: model.count === 0;
        running: visible;
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        contentWidth: parent.width

        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Theme.paddingMedium;

            PageHeader {
                //% "Checkin"
                title: qsTrId("checkin-result-title")
            }


            Label {
                id: message_text
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.leftMargin: Theme.paddingMedium;
                anchors.rightMargin: Theme.paddingMedium
            }

            SectionHeader {
                //% "Special"
                text: qsTrId("checkin-result-section-header-special")
                visible: special_message_label.visible
            }

            Label {
                id: special_message_label;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.leftMargin: Theme.paddingMedium;
                anchors.rightMargin: Theme.paddingMedium
                visible: (special_message_label.text != "");
                color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap

            }

            SectionHeader {
                //% "Badges"
                text: qsTrId("checkin-result-section-header-badges")
                visible: (badges_model.count > 0)
            }

            Repeater {
                model: badges_model
                delegate:  BackgroundItem {
                    id: badges_delegate
                    height: contentItem.childrenRect.height

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: Theme.paddingMedium
                        Label {
                            text: name
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter

                            anchors.leftMargin: Theme.paddingMedium
                            anchors.rightMargin: Theme.paddingMedium
                            color: badges_delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            wrapMode: Text.Wrap
                        }

                        Image {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: image.prefix + 200 + image.name
                            width: 200;
                            height: 200;
                        }
                        Label {
                            text: unlockMessage
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: Theme.paddingMedium
                            anchors.rightMargin: Theme.paddingMedium
                            color: badges_delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            wrapMode: Text.Wrap

                        }
                        Label {
                            text: description
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: Theme.paddingMedium
                            anchors.rightMargin: Theme.paddingMedium
                            color: badges_delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }

            SectionHeader {
                //% "Score"
                text: qsTrId("checkin-result-section-header-score")
            }

            Repeater {
                model: model
                delegate:  BackgroundItem {
                    id: delegate
                    height: contentItem.childrenRect.height

                    Image {
                        id: scoreIcon
                        source: icon
                        anchors.left: parent.left;
                        anchors.top: parent.top;
                        anchors.topMargin: Theme.paddingMedium;
                        anchors.leftMargin: Theme.paddingMedium;
                        anchors.rightMargin: Theme.paddingMedium
                        width: 22
                        height: width
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
            }

            SectionHeader {
                //% "Leaderboard"
                text: qsTrId("checkin-result-section-header-leaderboard")
            }

            Repeater {
                model: leaderboard_model;
                delegate: BackgroundItem {
                    id: leaderboard_delegate
                    height: Math.max(leaderBoardUserImage.height, leaderboardName.height + leaderboardCheckins.height)
                    Image {
                        id: leaderBoardUserImage
                        anchors.top: parent.top;
                        anchors.left: parent.left;
                        anchors.leftMargin: Theme.paddingMedium;
                        source: user.photo.prefix + width + user.photo.suffix
                        width: 80
                        height: width
                    }

                    Label {
                        id: leaderboardName
                        anchors.top: parent.top;
                        anchors.left: leaderBoardUserImage.right
                        anchors.right: parent.right
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.rightMargin: Theme.paddingMedium
                        text: ((user.firstName !== undefined) ? user.firstName + " " : "") + ((user.lastName !== undefined) ? user.lastName : "");
                        color: leaderboard_delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        wrapMode: Text.Wrap
                    }
                    Label {
                        id: leaderboardCheckins
                        anchors.top: leaderboardName.bottom;
                        anchors.left: leaderBoardUserImage.right
                        anchors.right: parent.right
                        anchors.topMargin: Theme.paddingSmall
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.rightMargin: Theme.paddingMedium

                        //% "%n checkins"
                        text: qsTrId("leaderboard-n-checkins", scores.checkinsCount);
                        wrapMode: Text.Wrap
                        color: leaderboard_delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    }

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingMedium
                        text: scores.recent
                        color: leaderboard_delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        wrapMode: Text.Wrap

                    }
                }

            }




        }
        VerticalScrollDecorator {}
    }

}





