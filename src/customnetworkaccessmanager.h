#ifndef CUSTOMNETWORKACCESSMANAGER_H
#define CUSTOMNETWORKACCESSMANAGER_H

#include <QNetworkAccessManager>
#include <QtNetwork>

class CustomNetworkAccessManager : public QNetworkAccessManager {
    Q_OBJECT
public:
    explicit CustomNetworkAccessManager(QObject *parent = 0);

protected:
    QNetworkReply *createRequest( Operation op, const QNetworkRequest &req, QIODevice * outgoingData=0 )
    {

        QNetworkRequest new_req(req);
        new_req.setRawHeader("User-Agent", m_userAgent. toLatin1());
        QNetworkReply *reply = QNetworkAccessManager::createRequest( op, new_req, outgoingData );
        return reply;
    }

private:
    QString m_userAgent;
};

#endif // CUSTOMNETWORKACCESSMANAGER_H

