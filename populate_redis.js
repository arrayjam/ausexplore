var redis = require("redis"),
  client = redis.createClient(),
  dsv = require("dsv"),
  fs = require("fs"),
  path = require("path"),
  d3 = require("d3");

var file = qualify("data/national_regional_profile.csv");
fs.readFile(file.path, "ascii", function(error, text) {
  if (error) return err(error);

  if (text === undefined) return;
  var profileCSV = dsv.csv.parse(text);
  var regionField = "SA2_MAIN";

  profileCSV.forEach(function(row) {
    var region = row[regionField];
    for (var prop in row) {
      if (row.hasOwnProperty(prop) && prop !== regionField) {
        client.hset(prop, region, row[prop]);
      }
    }
  });

  process.exit(0);
});

function qualify(file) {
  return {
    name: path.basename(file, path.extname(file)),
    path: file
  };
}

function err(error) {
  console.log("Error " + error);
}


//dsv.csv.parse("data/national_regional_profile.csv").forEach(function(row) {
//  console.log(row);
//});
//
//
//
//client.set("string key", "string val", redis.print);
//client.hset("hash key", "hashtest 1", "some value", redis.print);
//client.hset(["hash key", "hashtest 2", "some other value"], redis.print);
//client.hkeys("hash key", function (err, replies) {
//  console.log(replies.length + " replies:");
//  replies.forEach(function (reply, i) {
//    console.log("    " + i + ": " + reply);
//  });
//  client.quit();
//});
