#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QDebug>
#include <QMimeDatabase>
#include <QMimeType>
#include <QGuiApplication>
#include <QScreen>

#include "systemutils.h"

SystemUtils* SystemUtils::s_shared = nullptr;

SystemUtils::SystemUtils(QObject *parent) : QObject(parent)
{

}
//
//
//
SystemUtils* SystemUtils::shared() {
    if ( !s_shared ) {
        s_shared = new SystemUtils();
    }
    return s_shared;
}
//
//
//
QString SystemUtils::applicationDirectory() {
    return QCoreApplication::applicationDirPath();
}

QString SystemUtils::documentDirectory() {
    QString documentPath;
#ifdef Q_OS_ANDROID
    documentPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
#else
    documentPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
#endif
    QDir dir(documentPath);
    if ( dir.mkpath("smarttable") ) { // ensure directory exists, TDOD: set application name
        dir.cd("smarttable");
        if ( !dir.exists("media") ) { // TODO: move this somewhere more sensible
            dir.mkdir("media");
        }
    }
    return dir.canonicalPath();
}

QString SystemUtils::temporaryDirectory() {
    return QDir::tempPath();
}

QString SystemUtils::mediaPath( const QString& filename ) {
    return documentDirectory().append("/media/").append(filename);
}
//
//
//
bool SystemUtils::fileExists(const QString &path) {
    return QFile::exists(path);
}

bool SystemUtils::copyFile( const QString& from, const QString& to, bool force ) {
    if ( force ) {
        if ( QFile::exists(to) ) {
            QFile::remove(to);
        }
    }
    return QFile::copy( from, to );
}
bool SystemUtils::moveFile( const QString& from, const QString& to, bool force ) {
    if ( force ) {
        if ( QFile::exists(to) ) {
            QFile::remove(to);
        }
    }
    return QFile::rename( from, to );
}
bool SystemUtils::removeFile( const QString& path ) {
    if ( QFile::exists(path) ) {
        qDebug() << "SystemUtils::removeFile : " << path;
        if ( QFile::remove(path) ) {
            qDebug() << "SystemUtils::removeFile : file removed";
            return true;
        }
    }
    return false;
}
//
//
//
QString SystemUtils::mimeTypeForFile( QString filename ) {
    QMimeDatabase mimeDb;
    QMimeType mimeType = mimeDb.mimeTypeForFile(filename);
    return mimeType.name();
}
