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

    PlController = new PlauncherController();

    //default_websetting = QWebEngineSettings::globalSettings();
    //default_websetting->setAttribute(QWebEngineSettings::ScrollAnimatorEnabled,false);
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

    QString launcher = "ProcessLauncher";
    qml_context->setContextProperty(launcher, PlController);

    //engine.contextForObject()

    return true;
}

void XReaderContext::slot_a(QString arg) {
    qDebug() << "XReaderContext::slot_a toggled with arg:[" << arg << "]";
}

void XReaderContext::slot_run(QString app, QString arg) {
    QStringList arglist;
    if(!arg.isEmpty())
        arglist = arg.split(",");

    PlController->launchProcessWithArg(app, arglist);
}

int XReaderContext::gu(int size) {
    qreal res = m_dpi_ratio * size;
    return res < 0.5 ? 1 : qRound(res);
}
