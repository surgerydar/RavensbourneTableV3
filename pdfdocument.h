#ifndef PDFDOCUMENT_H
#define PDFDOCUMENT_H

#include <QQuickItem>
#include "fpdfview.h"
class PDFDocument : public QQuickItem
{
    Q_OBJECT
public:
    explicit PDFDocument(QQuickItem *parent = 0);
    //
    //
    //
    static void init();
    static void cleanup();
signals:

public slots:
    bool load( const QString path );
    void print();
private:
    FPDF_DOCUMENT m_document;
};

#endif // PDFDOCUMENT_H
