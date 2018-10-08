QT += qml quick serialport webengine printsupport

QTPLUGIN += qtvirtualkeyboardplugin

CONFIG += c++11

SOURCES += main.cpp \
    windowcontrol.cpp \
    systemutils.cpp \
    jsonfile.cpp \
    softkey.cpp \
    timeout.cpp \
    pdfdocument.cpp \
    barcodescanner.cpp \
    emailsender.cpp \
    smtp.cpp \
    debuglogger.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    barcodescanner.h \
    windowcontrol.h \
    systemutils.h \
    jsonfile.h \
    softkey.h \
    timeout.h \
    pdfdocument.h \
    emailsender.h \
    smtp.h \
    debuglogger.h

osx {
    INCLUDEPATH += ./pdfium-darwin/include
    QMAKE_SONAME_PREFIX = @executable_path
    LIBS += $${PWD}/pdfium-darwin/lib/libpdfium.dylib
    PDF_LIBS.files  = $${PWD}/pdfium-darwin/lib/libpdfium.dylib
    PDF_LIBS.path   = Contents/MacOS
    QMAKE_BUNDLE_DATA += PDF_LIBS
}

win32 {
    INCLUDEPATH += ./pdfium-windows/include
    LIBS += $${PWD}/pdfium-windows/x64/lib/pdfium.dll.lib
}
