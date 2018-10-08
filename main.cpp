#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngine/qtwebengineglobal.h>

#include "barcodescanner.h"
#include "windowcontrol.h"
#include "systemutils.h"
#include "jsonfile.h"
#include "softkey.h"
#include "timeout.h"
#include "pdfdocument.h"
#include "emailsender.h"
#include "debuglogger.h"

int main(int argc, char *argv[])
{
    //
    //
    //
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    //
    //
    //
    QtWebEngine::initialize();
    //
    //
    //
    QQmlApplicationEngine engine;
    //
    //
    //
    DebugLogger::shared()->setup();
    engine.rootContext()->setContextProperty("DebugLogger", DebugLogger::shared());
    //
    //
    //
    qmlRegisterType<SoftKey>("SodaControls", 1, 0, "SoftKey");
    //
    //
    //
    PDFDocument::init();
    qmlRegisterType<PDFDocument>("SodaControls", 1, 0, "PDFDocument");
    qmlRegisterType<EmailSender>("SodaControls", 1, 0, "EmailSender");
    //
    //
    //
    engine.rootContext()->setContextProperty("WindowControl", WindowControl::shared());
    engine.rootContext()->setContextProperty("BarcodeScanner", BarcodeScanner::shared());
    engine.rootContext()->setContextProperty("SystemUtils", SystemUtils::shared());
    engine.rootContext()->setContextProperty("JSONFile", JSONFile::shared());
    engine.rootContext()->setContextProperty("Timeout", Timeout::shared());
    //
    //
    //
    //BarcodeScanner::shared()->connect();
    //
    //
    //
    app.installEventFilter(Timeout::shared());
    //
    //
    //
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
