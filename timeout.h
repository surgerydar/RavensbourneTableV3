#ifndef TIMEOUT_H
#define TIMEOUT_H

#include <QObject>
#include <QDateTime>
#include <QTimer>

class Timeout : public QObject
{
    Q_OBJECT
public:
    explicit Timeout(QObject *parent = 0);
    static Timeout* shared();

signals:
    void timeout();

public slots:
    void registerEvent();
    void setTimeout(int timeout) { m_timeout = timeout; }
    int getTimeout() { return m_timeout; }
private slots:
    void signalTimeOut();

protected:
    bool eventFilter(QObject *obj, QEvent *event);
private:
    static Timeout* s_shared;
    void resetTimer();
    QTimer  m_timer;
    int     m_timeout;
};

#endif // TIMEOUT_H
