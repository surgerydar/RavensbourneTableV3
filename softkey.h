#ifndef SOFTKEY_H
#define SOFTKEY_H

#include <QQuickPaintedItem>
#include <QColor>
#include <QFont>

class SoftKey : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int keyCode MEMBER m_keyCode)
    Q_PROPERTY(QColor backgroundColour MEMBER m_backgroundColour)
    Q_PROPERTY(QFont font MEMBER m_font)
    Q_PROPERTY(QObject* target MEMBER m_target)
public:
    explicit SoftKey(QQuickItem* parent = 0);
    //
    //
    //
    void paint(QPainter*painter) override;

signals:

public slots:

protected:
    void mouseMoveEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

private:
    int     m_keyCode;
    QColor  m_backgroundColour;
    QColor  m_textColour;
    QFont   m_font;
    QObject* m_target;
};

#endif // SOFTKEY_H
