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
    qml/NotificationsPage.qml \
    qml/FriendsPage.qml \
    qml/TipsPage.qml \
    qml/LeaderboardPage.qml

QT += webkit

HEADERS += \
    src/networkaccessmanagerfactory.h \
    src/customnetworkaccessmanager.h

i18n.files = i18n
i18n.path = /usr/share/$${TARGET}

INSTALLS += i18n


TRANSLATIONS +=  \
./i18n/harbour-foursail_cs_CZ.ts \
./i18n/harbour-foursail_da_DK.ts \
./i18n/harbour-foursail_de_DE.ts \
./i18n/harbour-foursail_el_GR.ts \
./i18n/harbour-foursail_en_US.ts \
./i18n/harbour-foursail_es_ES.ts \
./i18n/harbour-foursail_fr_FR.ts \
./i18n/harbour-foursail_it_IT.ts \
./i18n/harbour-foursail_nl_NL.ts \
./i18n/harbour-foursail_ru_RU.ts \
./i18n/harbour-foursail_tr_TR.ts \
./i18n/harbour-foursail_zh_CN.ts


QMAKE_LRELEASE = lrelease

updateqm.input = TRANSLATIONS
updateqm.output = ${QMAKE_FILE_BASE}.qm
updateqm.commands = $$QMAKE_LRELEASE -silent ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_BASE}.qm
updateqm.CONFIG += no_link target_predeps
QMAKE_EXTRA_COMPILERS += updateqm


CODECFORTR = UTF-8
CODECFORSRC = UTF-8
