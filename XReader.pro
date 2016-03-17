TEMPLATE = app

QT += qml quick widgets
QT += webview webenginewidgets

CONFIG += c++11

SOURCES += main.cpp \
    src/xreadercontext.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES +=

HEADERS += \
    src/xreadercontext.h
