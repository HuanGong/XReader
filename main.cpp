#include <QApplication>
#include <QtWebView>
#include <QWebEngineSettings>
#include <QQmlApplicationEngine>

#include "src/xreadercontext.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setWindowIcon(QIcon("qrc:/image/icon/app.png"));
    new XReaderContext();

    QtWebView::initialize();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
