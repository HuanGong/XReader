
function loadSelectedArticle(article_info) {
    if (content_loader.item.objectName == "webview") {
        content_loader.item.weburl = article_info.link
    } else {
        content_loader.source = "qrc:/src/ContentWebView.qml"
        content_loader.item.weburl = article_info.link
    }

}

function backToFeedManagerView() {
    chanel_page.visible = false;
    stack_view.pop();
}


function openApplistView() {
    var appListComponent = Qt.createComponent("qrc:/src/ApplistView.qml");
    if (appListComponent.status === Component.Ready) {
        var applistview = appListComponent.createObject(main_window, {});
        applistview.sigOpenApplication.connect(openApplication);
    } else {
        console.log("conmentnet not ready"+ component.errorString())
    }
}

function openApplication(name, appurl) {
    console.log(name, appurl);
    content_loader.source = appurl;
}
