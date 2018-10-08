#ifndef DEBUGLOGGER_H
#define DEBUGLOGGER_H

#include <QObject>

class DebugLogger : public QObject
{
    Q_OBJECT
public:
    explicit DebugLogger(QObject *parent = 0);
    //
    //
    //
    static DebugLogger* shared();
    //
    //
    //
    void log( QString message );

public slots:
    void setup();
    void activate() { m_active = true; }
    void deactivate() { m_active = false; }

signals:
    void newMessage( QString message );

private:
    static DebugLogger* s_shared;
    //
    //
    //
    bool m_active;
};

#endif // DEBUGLOGGER_H
