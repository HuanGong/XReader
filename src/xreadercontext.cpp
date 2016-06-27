#include "xreadercontext.h"

#include "plauncher.h"
#include "plaunchercontroller.h"

XReaderContext::XReaderContext() {
    std::cout << "XReaderContext constructor called" << std::endl;

    PlController = new PlauncherController();
    //pl = new Plauncher();
    //QString app("/Users/gh/Desktop/youtube-dl");
    //pl->launch(app);


    //default_websetting = QWebEngineSettings::globalSettings();
    //default_websetting->setAttribute(QWebEngineSettings::ScrollAnimatorEnabled,false);

    //default_websetting->setFontSize(QWebEngineSettings::DefaultFontSize, 19);
    //default_websetting->setFontSize(QWebEngineSettings::DefaultFixedFontSize, 20);
}

XReaderContext::~XReaderContext() {

}
