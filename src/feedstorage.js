.import QtQuick.LocalStorage 2.0 as Sql

var db;
var MaxStorageSize = 4*1024*1024; //4M

function initDatabase() {
    print('initDatabase()')

    db = Sql.LocalStorage.openDatabaseSync("FeedDB", "1.0", "a db storage all feeds infomation", MaxStorageSize);
    db.transaction( function(tx) {
        print('... create and init database table')
        tx.executeSql('CREATE TABLE IF NOT EXISTS FeedDB(name TEXT, feedurl TEXT)');
    });
    //clearDataBase();
    //insertData({"name":"Oschina", "feed": "http://www.oschina.net/news/rss?show=industry"})
    //insertData({"name":"Baidu", "feed": "mm"})
}

function readData() {
    if(!db) { return; }

    db.transaction( function(tx) {
        var result = tx.executeSql('select * from FeedDB');

        for (var index = 0; index < result.rows.length; index++) {
            var value = result.rows[index];
            feed_data.insert(feed_data.count,{"name": value.name,
                                              "feed": value.feedurl,
                                              "colorCode": "#218868"});
        }
    });
}

function readDataWithFilter(filter) {
    if(!db) { return; }

    db.transaction( function(tx) {
        var result = tx.executeSql('select * from FeedDB where ');

        for (var index = 0; index < result.rows.length; index++) {
            var value = result.rows[index];

            feed_data.insert(feed_data.count,{"name": value.name,
                                              "feed": value.feedurl,
                                              "colorCode": "#218868"});
        }
    });
}

function storeData() {
    if(!db) { return; }
}


function insertData(feedInfo) {
    if(!db) { return; }

    db.transaction( function(tx) {
        var result = tx.executeSql('SELECT * from FeedDB where feedurl = ?', [feedInfo.feed]);
        print(JSON.stringify(result));
        if (result.rows.length > 0) {
            return;
        } else {
            result = tx.executeSql('INSERT INTO FeedDB VALUES (?,?)', [feedInfo.name, feedInfo.feed]);
            print(JSON.stringify(result));
        }
    });
}

function clearDataBase() {
    if(!db) { return; }
    db.transaction( function(tx) {
        var result = tx.executeSql('DELETE FROM FeedDB');
    });
}

function removeData(feedInfo) {
    if(!db) { return;}
    print(feedInfo.feed)
    db.transaction( function(tx) {
        var result = tx.executeSql('DELETE FROM FeedDB WHERE feedurl = ?', [feedInfo.feed]);
        print(JSON.stringify(result));
    });
}


