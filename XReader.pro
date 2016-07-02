TEMPLATE = app

QT += qml quick webengine

CONFIG += c++11

SOURCES += main.cpp \
    src/xreadercontext.cpp \
    src/plauncher.cpp \
    src/plaunchercontroller.cpp

include(./thirdparty/QZXing/QZXing.pri)
RESOURCES += qml.qrc

RC_FILE = XReader.rc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES +=

HEADERS += \
    src/xreadercontext.h \
    src/plauncher.h \
    src/plaunchercontroller.h \
    src/x_base.h
