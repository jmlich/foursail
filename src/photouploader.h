#ifndef PHOTOUPLOADER_H
#define PHOTOUPLOADER_H

#include <QObject>
#include <QUrl>
#include <QNetworkReply>

class QNetworkAccessManager;

class PhotoUploader : public QObject
{
	Q_OBJECT

	QNetworkAccessManager *nm;

public:
	PhotoUploader (QObject *parent = 0);

public slots:
	void uploadPhoto (const QUrl& path, const QString& targetId,
			bool publicPhoto, const QString& accessToken);

private slots:
	void handleUploadPhotoFinished ();
	void handleUploadPhotoProgress (qint64, qint64);
	void handleUploadPhotoError (QNetworkReply::NetworkError);
};

#endif // UTILS_H
