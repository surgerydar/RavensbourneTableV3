#include "pdfdocument.h"
#include <QPrinterInfo>
#include <QPrinter>
#include <QPainter>
#include <QFile>
#include <QList>

#include "fpdf_doc.h"

PDFDocument::PDFDocument(QQuickItem *parent) : QQuickItem(parent) {
    m_document = nullptr;
}

void PDFDocument::init() {
    FPDF_InitLibrary();
}

void PDFDocument::cleanup() {
    FPDF_DestroyLibrary();
}


bool PDFDocument::load( const QString path ) {
    if ( m_document != nullptr ) {
        FPDF_CloseDocument(m_document);
        m_document = nullptr;
    }
    if ( QFile::exists(path) ) {
        qDebug() << "PDFDocument::load : loading file : " << path;
        std::string str_path = path.toStdString();
        //qDebug() << "PDFDocument::load : " << str_path;
        m_document = FPDF_LoadDocument(str_path.c_str(), nullptr);
        if ( m_document == nullptr ) {
            qDebug() << "PDFDocument::load : unable to load file : " << path << " : error : " << FPDF_GetLastError();
        }
    } else {
        qDebug() << "PDFDocument::load : file not found : " << path;
    }
    return m_document != nullptr;
}

void PDFDocument::print() {
    if ( m_document ) {
        QPrinterInfo info = QPrinterInfo::defaultPrinter();
        if ( !info.isNull() ) {
            qDebug() << "PDFDocument::print : printing to : " << info.description();
            QPrinter printer(info);
            QList<int> resolutions = printer.supportedResolutions();
            qDebug() << "PDFDocument::print : current resolution : " << printer.resolution();
            qDebug() << "PDFDocument::print : supported resolutions";
            for ( auto& resolution : resolutions ) {
                qDebug() << resolution << "dpi";
                if ( resolution == 300 ) {
                    printer.setResolution(300);
                }
            }
            QPainter painter;
            qDebug() << "PDFDocument::print : begin printing";
            if ( painter.begin(&printer) ) {
                QRectF pageRect = printer.pageRect(QPrinter::DevicePixel);
                qDebug() << "PDFDocument::print : creating PDF bitmap : " << pageRect.width() << "x" << pageRect.height();
                FPDF_BITMAP bitmap = FPDFBitmap_Create(pageRect.width(),pageRect.height(),1);
                if ( bitmap ) {
                    qDebug() << "PDFDocument::print : creating image";
                    //QImage image((uchar*)FPDFBitmap_GetBuffer(bitmap),(int)pageRect.width(),(int)pageRect.height(),QImage::Format_RGBA8888);
                    QImage* image = new QImage((uchar*)FPDFBitmap_GetBuffer(bitmap),(int)pageRect.width(),(int)pageRect.height(),QImage::Format_RGBA8888);
                    if ( image ) {
                        int pageCount = FPDF_GetPageCount(m_document);
                        for ( int pageNo = 0; pageNo < pageCount; ++pageNo ) {
                            qDebug() << "PDFDocument::print : loading page " << pageNo << " of " << pageCount;
                            FPDF_PAGE page = FPDF_LoadPage(m_document, pageNo);
                            if ( page ) {
                                //
                                // clear image
                                //
                                qDebug() << "PDFDocument::print : clearing image";
                                //image.fill(Qt::white);
                                image->fill(Qt::white);
                                //
                                // render PDF into image
                                //
                                qDebug() << "PDFDocument::print : rendering page";
                                FPDF_RenderPageBitmap(bitmap,page,0,0,pageRect.width(),pageRect.height(),0,0);
                                //
                                // draw image
                                //
                                qDebug() << "PDFDocument::print : drawing image";
                                //painter.drawImage(pageRect.x(),pageRect.y(),image);
                                QImage swapped = image->rgbSwapped();
                                painter.drawImage(pageRect.x(),pageRect.y(),swapped);
                                //
                                // cleanup page
                                //
                                qDebug() << "PDFDocument::print : closing page";
                                FPDF_ClosePage(page);
                                //
                                // create new page
                                //
                                //if ( pageNo < pageCount - 1 ) printer.newPage();
                                printer.newPage();
                            } else {
                                qDebug() << "PDFDocument::print : unable load page " << pageNo << " of " << pageCount;
                            }
                        }
                        qDebug() << "PDFDocument::print : destroying image";
                        delete image;
                    } else {
                        qDebug() << "PDFDocument::print : unable to create image";
                    }
                    //
                    // cleanup bitmap
                    //
                    qDebug() << "PDFDocument::print : destroying bitmap";
                    FPDFBitmap_Destroy(bitmap);
                } else {
                    qDebug() << "PDFDocument::print : unable to create PDF bitmap";
                }
                //
                // end painting
                //
                qDebug() << "PDFDocument::print : end printing";
                painter.end();
            } else {
                qDebug() << "PDFDocument::print : unable to create begin painting";
            }
        } else {
            qDebug() << "PDFDocument::print : unable to find default printer";
        }
    } else {
        qDebug() << "PDFDocument::print : document not loaded";
    }
    qDebug() << "PDFDocument::print : done";
}

