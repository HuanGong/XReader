#include <QtWebEngine>
#include <QQmlApplicationEngine>

#include "src/xreadercontext.h"
#include "QZXing.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QZXing::registerQMLTypes();
    QtWebEngine::initialize();

    QQmlApplicationEngine engine;

    XReaderContext* context = new XReaderContext(&engine);
    context->Init();

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    std::cout << engine.rootObjects().count() << std::endl;

    //start messageloop
    return app.exec();
}
