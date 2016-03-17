#include "xreadercontext.h"

XReaderContext::XReaderContext() {
    std::cout << "XReaderContext constructor called" << std::endl;

    default_websetting = QWebEngineSettings::globalSettings();
    default_websetting->setAttribute(QWebEngineSettings::ScrollAnimatorEnabled,false);

    default_websetting->setFontSize(QWebEngineSettings::DefaultFontSize, 19);
    default_websetting->setFontSize(QWebEngineSettings::DefaultFixedFontSize, 20);
}

XReaderContext::~XReaderContext() {

}
