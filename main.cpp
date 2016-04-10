#include <QtWebEngine>
#include <QQmlApplicationEngine>

#include "src/xreadercontext.h"
#include "QZXing.h"

int main(int argc, char *argv[])
{
    //QApplication app(argc, argv);
    QGuiApplication app(argc, argv);

    QZXing::registerQMLTypes();
    //app.setWindowIcon(QIcon("qrc:/image/icon/app.png"));
    new XReaderContext();

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
