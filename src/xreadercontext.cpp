#include "xreadercontext.h"

#include "plauncher.h"
#include "plaunchercontroller.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "x_base.h"

#include <QScreen>
#include <QGuiApplication>

XReaderContext::XReaderContext(QQmlApplicationEngine* engine,
                               QObject* parent)
    : QObject(parent),
      m_engine(engine)
{

    QScreen *screen = QGuiApplication::primaryScreen();
    qDebug() << "screen width" << screen->size().width();
    qDebug() << "devicePixelRatio: " << screen->devicePixelRatio();
    qDebug() << "logicalDotsPerInch:" << screen->logicalDotsPerInch();
    qDebug() << "physicalDotsPerInch:" << screen->physicalDotsPerInch();
    qDebug() << "physicalDotsPerInch/logicalDotsPerInch:" << screen->physicalDotsPerInch()/screen->logicalDotsPerInch();
    qDebug() << "physicalDotsPerInchX/logicalDotsPerInchX:" << screen->physicalDotsPerInchX()/screen->logicalDotsPerInchX();
    qDebug() << "screenwidth/1366 ratio:" << screen->size().width()/1280.0;

    m_dpi_ratio = screen->physicalDotsPerInch()/screen->logicalDotsPerInch();
    std::cout << "============================================" << std::endl;

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


int XReaderContext::gu(int size) {
    qreal res = m_dpi_ratio * size;
    return res < 0.5 ? 1 : qRound(res);
}
