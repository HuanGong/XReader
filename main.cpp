#include <QApplication>
#include <QtWebView>
#include <QWebEngineSettings>
#include <QQmlApplicationEngine>

#include "src/xreadercontext.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QtWebView::initialize();

    new XReaderContext();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
