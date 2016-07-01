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
    Q_INVOKABLE int gu(int size) {
        printf("pass in size:%d, return scale szie:%f", size, m_dpi_ratio*size);
        return m_dpi_ratio*size;
    }
    Q_INVOKABLE int reken_tijden_uit(){
      qDebug() << "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
      return 1;
    }


public slots:
    void slot_a(QString arg);

private:
    PlauncherController* PlController;

    QQmlApplicationEngine* m_engine;

    double m_dpi_ratio;


    //this pointer not need delete
    //QWebEngineSettings *default_websetting;
};

#endif // XREADERCONTEXT_H
