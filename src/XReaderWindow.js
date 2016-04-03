
function loadSelectedArticle(article_info) {
    if (content_loader.item.objectName == "webview") {
        content_loader.item.weburl = article_info.link
    } else {
        content_loader.source = "qrc:/src/RssContentWebView.qml"
        content_loader.item.weburl = article_info.link
    }

}

function backToFeedManagerView() {
    chanel_page.visible = false;
    stack_view.pop();
}
