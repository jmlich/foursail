# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-foursail

CONFIG += sailfishapp

SOURCES += src/harbour-foursail.cpp \
    src/networkaccessmanagerfactory.cpp \
    src/customnetworkaccessmanager.cpp

OTHER_FILES += qml/harbour-foursail.qml \
    qml/CoverPage.qml \
    rpm/harbour-foursail.spec \
    rpm/harbour-foursail.yaml \
    harbour-foursail.desktop \
    qml/Data.qml \
    qml/RecentCheckinsPage.qml \
    qml/functions.js \
    qml/NearbyVenuesPage.qml \
    qml/CheckinResultPage.qml \
    qml/CheckinDetailPage.qml \
    qml/AddVenuePage.qml \
    qml/MapPage.qml \
    qml/PinchMap.qml \
    qml/SelfCheckinsPage.qml \
    qml/MyProfilePage.qml \
    qml/SearchVenueDialog.qml \
    qml/FriendDetailPage.qml \
    qml/BadgesPage.qml \
    qml/CategoriesPage.qml \
    qml/NotificationPopup.qml \
    qml/NotificationsPage.qml

QT += webkit

HEADERS += \
    src/networkaccessmanagerfactory.h \
    src/customnetworkaccessmanager.h




i18n.files = i18n
i18n.path = /usr/share/$${TARGET}

INSTALLS += i18n


TRANSLATIONS +=  ./i18n/harbour-foursail_en_EN.ts

CODECFORTR = UTF-8
CODECFORSRC = UTF-8
