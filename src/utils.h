#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QUrl>

class Utils : public QObject
{
	Q_OBJECT
public:
	Utils (QObject *parent = 0);

	Q_INVOKABLE QByteArray getFileContent (const QUrl& path);
};

#endif // UTILS_H
