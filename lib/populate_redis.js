var redis = require("redis"),
  client = redis.createClient(),
  dsv = require("dsv"),
  fs = require("fs"),
  path = require("path"),
  d3 = require("d3"),
  _ = require("underscore");

client.select(88);

var file = qualify("data/national_regional_profile.csv");
fs.readFile(file.path, "ascii", function(error, text) {
  if (error) return err(error);

  if (text === undefined) return;
  var profileCSV = dsv.csv.parse(text);
  var regionField = "SA2_MAIN";

  _.without(d3.keys(profileCSV[0]), "year", "SA2_MAIN", "region_name").forEach(function(key) {
    client.sadd("props", key);
  });

  profileCSV.forEach(function(row) {
    var region = row[regionField];
    for (var prop in row) {
      if (row.hasOwnProperty(prop) && prop !== regionField) {
        client.hset(prop, region, row[prop]);
      }
    }
  });

  client.quit();
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

