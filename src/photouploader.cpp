#include "photouploader.h"
#include <QFile>
#include <QUrl>
#include <QUrlQuery>
#include <QNetworkRequest>
#include <QtDebug>
#include <QNetworkAccessManager>
#include <QHttpMultiPart>

PhotoUploader::PhotoUploader (QObject *parent)
: QObject (parent)
, nm (new QNetworkAccessManager (this))
{
}

void PhotoUploader::uploadPhoto (const QUrl& path, const QString& targetId,
		bool publicPhoto, const QString& accessToken)
{
	QUrl source ("https://api.foursquare.com/v2/photos/add");
	QUrlQuery query;
	query.addQueryItem ("oauth_token", accessToken);
	query.addQueryItem ("v", "20131016");
	query.addQueryItem ("locale", "en");
	query.addQueryItem ("checkinId", targetId);
	query.addQueryItem ("public", publicPhoto ? "1" : "0");
	source.setQuery (query);

	QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

	QHttpPart imagePart;
	imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
	imagePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"photo\"; filename=\"image.jpg\""));
	QFile *file = new QFile(path.toLocalFile ());
	file->open(QIODevice::ReadOnly);
	imagePart.setBodyDevice(file);
	file->setParent(multiPart); // we cannot delete the file now, so delete it with the multiPart

	multiPart->append(imagePart);

	QNetworkRequest request (source);
	QNetworkReply *reply = nm->post (request, multiPart);
	connect (reply,
			SIGNAL (finished ()),
			this,
			SLOT (handleUploadPhotoFinished ()));
	connect (reply,
			SIGNAL (error (QNetworkReply::NetworkError)),
			this,
			SLOT (handleUploadPhotoError (QNetworkReply::NetworkError)));
	connect (reply,
			SIGNAL (uploadProgress(qint64, qint64)),
			this,
			SLOT (handleUploadPhotoProgress (qint64, qint64)));
	file->setParent (reply);
}

void PhotoUploader::handleUploadPhotoFinished()
{
	QNetworkReply *reply = qobject_cast<QNetworkReply*> (sender ());
	if (!reply)
		return;

	reply->deleteLater ();

	qDebug () << reply->readAll ();
}

void PhotoUploader::handleUploadPhotoProgress(qint64 t1, qint64 t2)
{
	qDebug () << t1 << t2;
}

void PhotoUploader::handleUploadPhotoError(QNetworkReply::NetworkError err)
{
	QNetworkReply *reply = qobject_cast<QNetworkReply*> (sender ());
	if (!reply)
		return;
	qDebug () << err << reply->errorString();
}
