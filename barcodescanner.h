#ifndef BARCODESCANNER_H
#define BARCODESCANNER_H

#include <QObject>
#include <QMap>

#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
#include <QSerialPort>
class BarcodeScanner : public QObject
{
    Q_OBJECT
public:
    BarcodeScanner();
    virtual ~BarcodeScanner();
    static BarcodeScanner* shared();
    void readData( const QString& port_name );


private:
    static BarcodeScanner*      s_shared;
    QMap<QString,QSerialPort*>  m_ports;
signals:
    void newCode(QString portname, QString barcode);

public slots:
    void connect();
    void disconnect();
    quint32 count();
    void test();
};

#endif

#endif // BARCODESCANNER_H
