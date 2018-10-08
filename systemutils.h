#ifndef SYSTEMUTILS_H
#define SYSTEMUTILS_H

#include <QObject>
#include <QThread>


class SystemUtils : public QObject
{
    Q_OBJECT
public:
    explicit SystemUtils(QObject *parent = 0);
    static SystemUtils* shared();
private:
    static SystemUtils* s_shared;
public slots:
    //
    //
    //
    QString applicationDirectory();
    QString documentDirectory();
    QString temporaryDirectory();
    //
    //
    //
    QString mediaPath( const QString& filename );
    //
    //
    //
    bool fileExists( const QString& path );
    bool copyFile( const QString& from, const QString& to, bool force = false );
    bool moveFile( const QString& from, const QString& to, bool force = false );
    bool removeFile( const QString& path );
    //
    //
    //
    QString mimeTypeForFile( QString filename );
    //
    //
    //
};

#endif // SYSTEMUTILS_H
