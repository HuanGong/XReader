
function loadSelectedArticle(article_info) {
    console.log(article_info, "==================")

    if (content_loader.item.objectName == "webview") {
        content_loader.item.weburl = article_info.link
    }

}

function backToFeedManagerView() {
    console.log("========I will back to FeedManagerView======")
    chanel_page.visible = false;
    stack_view.pop();
}
