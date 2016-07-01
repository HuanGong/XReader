#include "xreadercontext.h"

#include "plauncher.h"
#include "plaunchercontroller.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QScreen>
#include <QGuiApplication>

XReaderContext::XReaderContext(QQmlApplicationEngine* engine,
                               QObject* parent)
    : QObject(parent),
      m_engine(engine)
{

    QScreen *screen = QGuiApplication::primaryScreen();
    m_dpi_ratio = screen->size().width()/1280;
    std::cout << "XReaderContext constructor called" << std::endl;

    PlController = new PlauncherController();

    /*
    QString app("ls");
    QStringList argv;
    argv << "-al" << "..";
    for (int a=1; a<1; a++) {
        PlController->launchProcessWithArg(app, argv);
    }*/

    //default_websetting = QWebEngineSettings::globalSettings();
    //default_websetting->setAttribute(QWebEngineSettings::ScrollAnimatorEnabled,false);

    //default_websetting->setFontSize(QWebEngineSettings::DefaultFontSize, 19);
    //default_websetting->setFontSize(QWebEngineSettings::DefaultFixedFontSize, 20);
}

XReaderContext::~XReaderContext() {
    if (PlController)
        delete PlController;
}


bool XReaderContext::Init() {
  //export XReaderContext to qml
    QString objproperty = "XReaderContext";
    QQmlContext* qml_context = m_engine->rootContext();
    qml_context->setContextProperty(objproperty,this);
    //engine.contextForObject()

    return true;
}

void XReaderContext::slot_a(QString arg) {
    qDebug() << arg;
    printf("\n\n==========#########================\n\n"); fflush(NULL);
}

/*
int XReaderContext::gu(int size) {
    printf("pass in size:%d, return scale szie:%d", size, m_dpi_ratio*size);
    return m_dpi_ratio*size;
}*/
