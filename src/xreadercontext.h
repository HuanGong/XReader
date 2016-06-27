#ifndef XREADERCONTEXT_H
#define XREADERCONTEXT_H

#include <iostream>
#include <QObject>
//#include <qwebenginesettings.h>

class Plauncher;
class PlauncherController;

class XReaderContext
{
public:
    XReaderContext();
    virtual ~XReaderContext();

private:
    PlauncherController* PlController;
    //this pointer not need delete
    //QWebEngineSettings *default_websetting;
};

#endif // XREADERCONTEXT_H
