#include <QPainter>
#include <QKeyEvent>
#include <QDebug>
#include <QCoreApplication>
#include "softkey.h"
/*

Qt::Key_NumberSign
Qt::Key_Dollar
Qt::Key_Percent
Qt::Key_Ampersand
Qt::Key_Apostrophe
Qt::Key_ParenLeft
Qt::Key_ParenRight
Qt::Key_Asterisk
Qt::Key_Plus
Qt::Key_Comma
Qt::Key_Minus
Qt::Key_Period
Qt::Key_Slash
Qt::Key_0
Qt::Key_1
Qt::Key_2
Qt::Key_3
Qt::Key_4
Qt::Key_5
Qt::Key_6
Qt::Key_7
Qt::Key_8
Qt::Key_9
Qt::Key_Colon
Qt::Key_Semicolon
Qt::Key_Less
Qt::Key_Equal
Qt::Key_Greater
Qt::Key_Question
Qt::Key_At
Qt::Key_A
Qt::Key_B
Qt::Key_C
Qt::Key_D
Qt::Key_E
Qt::Key_F
Qt::Key_G
Qt::Key_H
Qt::Key_I
Qt::Key_J
Qt::Key_K
Qt::Key_L
Qt::Key_M
Qt::Key_N
Qt::Key_O
Qt::Key_P
Qt::Key_Q
Qt::Key_R
Qt::Key_S
Qt::Key_T
Qt::Key_U
Qt::Key_V
Qt::Key_W
Qt::Key_X
Qt::Key_Y
Qt::Key_Z


  */

SoftKey::SoftKey(QQuickItem* parent) : QQuickPaintedItem( parent ) {
    setAcceptedMouseButtons(Qt::AllButtons);
    m_keyCode = Qt::Key_A;
    m_backgroundColour = QColor(253,195,0);
    m_textColour = QColor(255,255,255);
    m_target = nullptr;
}

void SoftKey::paint(QPainter*painter) {
    QRectF bounds( 0, 0, width(), height() );

    QString keyString;
    if(m_keyCode >= Qt::Key_Space && m_keyCode <= Qt::Key_AsciiTilde) {
        // handle ASCII char like keys
        keyString = QString( QChar(m_keyCode) );
    } else {
        // handle the other keys here...
        keyString = "?";
    }
    //
    // draw background
    //
    painter->save();
    painter->setBrush(QBrush(m_backgroundColour));
    painter->setPen(Qt::NoPen);
    painter->drawEllipse(0,0,width(),height());
    painter->restore();
    //
    // draw text
    //
    painter->setPen(QPen(m_textColour));
    painter->drawText(bounds, Qt::AlignVCenter | Qt::AlignHCenter, keyString);
}

void SoftKey::mouseMoveEvent(QMouseEvent *event) {

}

void SoftKey::mousePressEvent(QMouseEvent *event) {
    qDebug() << "SoftKey::mousePressEvent";
    if ( m_target ) {
        QKeyEvent press(QKeyEvent::KeyPress, m_keyCode, Qt::NoModifier);
        if ( !QCoreApplication::sendEvent(m_target,&press) ) {
            qDebug() << "SoftKey::mousePressEvent : target did not process event";
        }
    } else {
        qDebug() << "SoftKey::mousePressEvent : no target";
    }
}

void SoftKey::mouseReleaseEvent(QMouseEvent *event) {
    qDebug() << "SoftKey::mouseReleaseEvent";
    if ( m_target ) {
        QKeyEvent release(QKeyEvent::KeyRelease, m_keyCode, Qt::NoModifier);
        if (!QCoreApplication::sendEvent(m_target,&release) ) {
            qDebug() << "SoftKey::mouseReleaseEvent : target did not process event";
        }
    } else {
        qDebug() << "SoftKey::mouseReleaseEvent : no target";
    }
}
