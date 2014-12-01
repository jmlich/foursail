#include "utils.h"
#include <QFile>
#include <QtDebug>

Utils::Utils (QObject *parent)
: QObject (parent)
{
}

QByteArray Utils::getFileContent (const QUrl& path)
{
	QFile file (path.toLocalFile ());
	QByteArray content;
	if (file.open (QIODevice::ReadOnly))
		content = file.readAll ();
	file.close ();
	return content;
}
