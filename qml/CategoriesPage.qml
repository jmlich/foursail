import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {


    id: page

    property alias m: model

    signal selected(string cid, string name, url icon)

    ListModel {
        id: model;
    }


    BusyIndicator {
        anchors.centerIn: parent;
        visible: model.count === 0;
        running: visible;
    }

    SilicaListView {
        anchors.fill: parent;
        model: model;

        header: PageHeader {
            title: qsTr("Select Category")
        }

        delegate: BackgroundItem {
            Image {
                id: categoryIcon
                anchors.left: parent.left;
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
                width: 64;
                height: 64;
                source: icon.prefix + "64" + icon.suffix
            }
            Label {
                anchors.left: categoryIcon.right
                anchors.right: parent.right

                anchors.verticalCenter: parent.verticalCenter
                text: name
            }


            onClicked: {
                var component = Qt.createComponent(Qt.resolvedUrl("CategoriesPage.qml"));
                if (component.status === Component.Ready) {
                    var subpage = component.createObject(page);
                    if ((subcategories !== "") && (subcategories !== "[]")) {
                        var array = JSON.parse(subcategories)
                        for (var i = 0; i < array.length; i++) {
                            var item = array[i];
                            var data = {
                                'cid': item.id,
                                'name' : item.name,
                                'icon': item.icon,
                                'subcategories' : ((item.categories !== undefined) ? JSON.stringify(item.categories) : "")
                            }
                            subpage.m.append(data);
                        }

                        subpage.selected.connect(page.selectedSubCategory)

                        pageStack.push(subpage);
                    } else {
                        selected (cid, name, icon.prefix + "64" + icon.suffix)
                    }
                }

            }
        }

    }

    function selectedSubCategory(cid, name, icon) {
        selected(cid, name, icon)
    }
}
