#include "debuglogger.h"

#include <QDateTime>

static QtMessageHandler s_previousHandler = nullptr;

static void Logger(QtMsgType type, const QMessageLogContext & context, const QString & msg) {
    QString txt;
    QString time = QDateTime::currentDateTime().toString();
    switch (type) {
    case QtDebugMsg:
        txt = QString("%1 : DEBUG : %2").arg(time,msg);
        break;
    case QtWarningMsg:
        txt = QString("%1 : WARNING : %2").arg(time,msg);
        break;
    case QtCriticalMsg:
        txt = QString("%1 : CRITICAL : %2").arg(time,msg);
        break;
    case QtFatalMsg:
        txt = QString("%1 : FATAL : %2").arg(time,msg);
        break;
    default:
        txt = QString("%1 : UNKNOWN : %2").arg(time,msg);
        break;
    }
    //
    //
    //
    txt.replace("\"","\\\"");
    DebugLogger::shared()->log(txt);
    if ( s_previousHandler ) s_previousHandler(type, context, msg);
}

DebugLogger* DebugLogger::s_shared = nullptr;

DebugLogger::DebugLogger(QObject *parent) : QObject(parent) {
    m_active = false;
}
//
//
//
DebugLogger* DebugLogger::shared() {
    if ( s_shared == nullptr ) {
        s_shared = new DebugLogger;
    }
    return s_shared;
}
//
//
//
void DebugLogger::log( QString message ) {
    if ( m_active ) {
        emit newMessage( message );
    }
}

void DebugLogger::setup() {
    if ( s_previousHandler == nullptr ) {
        s_previousHandler = qInstallMessageHandler(Logger);
    }
}
