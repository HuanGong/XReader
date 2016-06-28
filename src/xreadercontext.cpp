#include "xreadercontext.h"

#include "plauncher.h"
#include "plaunchercontroller.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

XReaderContext::XReaderContext(QQmlApplicationEngine* engine,
                               QObject* parent)
    : QObject(parent),
      m_engine(engine)
{

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
