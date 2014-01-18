#ifndef NETWORKACCESSMANAGERFACTORY_H
#define NETWORKACCESSMANAGERFACTORY_H

#include <QtNetwork>
#include <QQmlNetworkAccessManagerFactory>
#include "customnetworkaccessmanager.h"

class NetworkAccessManagerFactory : public QQmlNetworkAccessManagerFactory
{
public:
    explicit NetworkAccessManagerFactory();

    QNetworkAccessManager* create(QObject* parent)
    {
        CustomNetworkAccessManager* manager = new CustomNetworkAccessManager(parent);
        return manager;
    }

};

#endif // NETWORKACCESSMANAGERFACTORY_H
