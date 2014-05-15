import QtQuick 2.0
import Sailfish.Silica 1.0
import QtDocGallery 5.0
import org.nemomobile.thumbnailer 1.0

Page {
    id: page;

    signal imageSelected (string url)

    DocumentGalleryModel {
        id: galleryModel
        rootType: DocumentGallery.Image
        properties: [ "url", "title", "dateTaken" ]
        autoUpdate: true
        sortProperties: ["dateTaken"]
        filter: GalleryWildcardFilter {
             property: "fileName";
             value: "*.jpg";
         }
    }

    SilicaGridView {
        id: grid
        header: PageHeader {
            id: pageHeader;
            //% "Images"
            title: qsTrId("images-title")
        }

        PullDownMenu {
            MenuItem {
                //% "From camera"
                text: qsTrId("images-from-camera-menu")
                //TODO
            }
        }

        cellWidth: galleryModel.count <= 6 ? grid.width / 2 : grid.width / 3
        cellHeight: cellWidth

        anchors.fill: parent

        model: galleryModel

        delegate: Image {
            asynchronous: true

            // From org.nemomobile.thumbnailer
            source:  "image://nemoThumbnail/" + url

            sourceSize.width: grid.cellWidth
            sourceSize.height: grid.cellHeight

            MouseArea {
                anchors.fill: parent
                onClicked: imageSelected (url)
            }
        }
        ScrollDecorator {}
    }
}
