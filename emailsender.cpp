#include "emailsender.h"
#include "smtp.h"
/*
 * host: 'smtp.gmail.com',
 * port: 465,
 * secure: true, // use SSL
 * auth: {
 *  user: 'ravensbournetable@gmail.com',
 *  pass: 'Ta8le202'
 * }
 */

EmailSender::EmailSender(QQuickItem* parent) : QQuickItem( parent ) {

}
//
//
//
void EmailSender::send( const QString& recipient, const QString& subject, const QString& message ) {

    if ( isConfigured() ) {
        Smtp* smtp = new Smtp(m_username,m_password,m_host,m_port);
        //
        // TODO: connect to signals
        //
        connect(smtp,&Smtp::status,this,&EmailSender::status);
        connect(smtp,&Smtp::error,this,&EmailSender::error);
        connect(smtp,&Smtp::done,this,&EmailSender::done);
        //
        // send mail
        //
        smtp->sendMail(m_email,recipient,subject,message);
    } else {
        emit error( "e-mail not configured" );
    }
}
//
//
//
bool EmailSender::isConfigured() {
    return m_email.length() > 0 && m_host.length() > 0 && m_username.length() > 0 && m_password.length() > 0;
}
