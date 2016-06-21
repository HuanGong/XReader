
/*
var request = require("request");
request("https://readability.com/api/content/v1/parser?url=http://www.gq.com/sports/profiles/201202/david-diamante-interview-cigar-lounge-brooklyn-new-jersey-nets?currentPage=all&token=7myToken", function(err, resp, body) {
console.log(body);
});


var request = require("request");
request('your-url', function(err, resp, body) {
    var parsedBody = JSON.parse(body);
    console.log(parsedBody.word_count);
});

var request = require("request");
request({
    url: 'your-url',
    json: true
}, function(err, resp, body) {
    console.log(body);
});
*/


function Readability() {

    var parseBase = "https://readability.com/api/content/v1/parser?url=";
    var endArgv = "?currentPage=all&token=b4d7273f53523173eac43edd078d90df733e8c98";

    this.readabilityGet = function (url, success, failure) {
        var xhr = new XMLHttpRequest;
        var parseurl = parseBase + url + endArgv;
        console.log(parseurl);
        xhr.open("GET", url);
        xhr.onreadystatechange = function (xhr, success, failure){
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status ===  200){
                    if (success !== null && success !== undefined)
                    {
                        var result = xhr.responseText;
                        try{
                            success(result, JSON.parse(result));
                            console.log("xxxxxxxxxxxxxxxx")
                        }catch(e){
                            success(result, {});
                        }
                    }
                }
                else{
                    if (failure !== null && failure !== undefined)
                        failure(xhr.responseText, xhr.status);
                }
            }
        }
        xhr.send();
    };



}

// GET


// POST
function post(url, arg, success, failure)
{
    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Length", arg.length);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;");  //用POST的时候一定要有这句
    xhr.onreadystatechange = function() {
        handleResponse(xhr, success, failure);
    }
    xhr.send(arg);
}

// 处理返回值

