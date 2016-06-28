#ifndef XREADERCONTEXT_H
#define XREADERCONTEXT_H

#include <iostream>
#include <QObject>
#include <QDebug>
//#include <qwebenginesettings.h>

class Plauncher;
class PlauncherController;
class QQmlApplicationEngine;

class XReaderContext: public QObject
{
    Q_OBJECT
public:
    XReaderContext(QQmlApplicationEngine* engine,QObject* parent=0);
    virtual ~XReaderContext();

    bool Init();

public slots:
    void slot_a(QString arg);

private:
    PlauncherController* PlController;

    QQmlApplicationEngine* m_engine;

    //this pointer not need delete
    //QWebEngineSettings *default_websetting;
};

#endif // XREADERCONTEXT_H
