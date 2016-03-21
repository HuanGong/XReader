#include <QApplication>
#include <QtWebView>
#include <QWebEngineSettings>
#include <QQmlApplicationEngine>

#include "src/xreadercontext.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    new XReaderContext();
    QtWebView::initialize();



    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
