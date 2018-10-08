#ifndef EMAILSENDER_H
#define EMAILSENDER_H

#include <QQuickItem>

class EmailSender : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString email MEMBER m_email)
    Q_PROPERTY(QString host MEMBER m_host)
    Q_PROPERTY(int port MEMBER m_port)
    Q_PROPERTY(QString username MEMBER m_username)
    Q_PROPERTY(QString password MEMBER m_password)

public:
    explicit EmailSender(QQuickItem* parent=nullptr);

signals:
    void status( QString error );
    void error( QString error );
    void done();

public slots:
    void send( const QString& recipient, const QString& subject, const QString& message );

private:
    bool isConfigured();
    QString m_email;
    QString m_host;
    int     m_port;
    QString m_username;
    QString m_password;
};

#endif // EMAILSENDER_H
