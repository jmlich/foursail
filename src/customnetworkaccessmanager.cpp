#include "customnetworkaccessmanager.h"

CustomNetworkAccessManager::CustomNetworkAccessManager(QObject *parent) : QNetworkAccessManager(parent)
{
    m_userAgent = " Mozilla/5.0 (Linux; U; Jolla; Sailfish; Mobile; rv:20.0) Gecko/20.0 Firefox/20.0 Foursail 0.3+";
}
