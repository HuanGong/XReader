#ifndef XREADERCONTEXT_H
#define XREADERCONTEXT_H

#include <iostream>
#include <QObject>
#include <qwebenginesettings.h>


class XReaderContext
{
public:
    XReaderContext();
    virtual ~XReaderContext();

private:
    //this pointer not need delete
    QWebEngineSettings *default_websetting;
};

#endif // XREADERCONTEXT_H
