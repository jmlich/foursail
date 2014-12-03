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
    src/customnetworkaccessmanager.cpp \
    src/photouploader.cpp

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
    qml/SearchVenueDialog.qml \
    qml/BadgesPage.qml \
    qml/CategoriesPage.qml \
    qml/NotificationPopup.qml \
    qml/NotificationsPage.qml \
    qml/FriendsPage.qml \
    qml/TipsPage.qml \
    qml/LeaderboardPage.qml \
    qml/ListsPage.qml \
    qml/ListDetailPage.qml \
    qml/AddAndEditListPage.qml \
    qml/PhotosPage.qml \
    qml/PhotoDetailPage.qml \
    qml/MayorshipsPage.qml \
    qml/ProfilePage.qml \
    qml/ImagesPage.qml

QT += webkit network

HEADERS += \
    src/networkaccessmanagerfactory.h \
    src/customnetworkaccessmanager.h \
    src/photouploader.h



# LANGUAGES = cs_CZ da_DK de_DE el_GR es_ES en_US fi_FI fr_FR it_IT nl_NL ru_RU tr_TR zh_CN af_ZA bg_BG pl_PL
LANGUAGES = cs_CZ de_DE el_GR en_US fi_FI it_IT nl_NL ru_RU tr_TR zh_CN af_ZA bg_BG pl_PL

# var, prepend, append
defineReplace(prependAll) {
    for(a,$$1):result += $$2$${a}$$3
    return($$result)
}

LRELEASE = lrelease

TRANSLATIONS = $$prependAll(LANGUAGES, $$PWD/i18n/harbour-foursail_,.ts)

updateqm.input = TRANSLATIONS
updateqm.output = $$OUT_PWD/${QMAKE_FILE_BASE}.qm
updateqm.commands = $$LRELEASE -idbased -silent ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_BASE}.qm
updateqm.CONFIG += no_link target_predeps
QMAKE_EXTRA_COMPILERS += updateqm

qmfiles.files = $$prependAll(LANGUAGES, $$OUT_PWD/harbour-foursail_,.qm)
qmfiles.path = /usr/share/$${TARGET}/i18n
qmfiles.CONFIG += no_check_exist

INSTALLS += qmfiles

CODECFORTR = UTF-8
CODECFORSRC = UTF-8
